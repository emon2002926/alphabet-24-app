
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/match_lineup_controller.dart';
import '../models/match_lineup_model.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';
import 'football_field_painter.dart';

class LineUpTab extends StatelessWidget {
  final int fixtureId;

  LineUpTab({super.key, required this.fixtureId});

  final MatchLineupController matchLineupController = Get.put(MatchLineupController());

  @override
  Widget build(BuildContext context) {
    matchLineupController.fetchLineup(fixtureId);

    return Obx(() {
      if (matchLineupController.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading lineup...'),
            ],
          ),
        );
      }

      if (matchLineupController.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: STextTheme.headLineBold().copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  matchLineupController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => matchLineupController.fetchLineup(fixtureId),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final MatchLineup? matchData = matchLineupController.lineupData.value;
      if (matchData == null) {
        return const Center(
          child: Text("No lineup data available"),
        );
      }

      final homeStarting = matchData.homeTeam.startingXi;
      final awayStarting = matchData.awayTeam.startingXi;

      if (homeStarting.isEmpty && awayStarting.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No lineup available for this match'),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // Todo Formation Display - Enhanced
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: _buildTeamFormation(
            //           matchData.homeTeam.name,
            //           matchData.homeTeam.formation,
            //           matchData.homeTeam.logo,
            //           Colors.blue,
            //         ),
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: _buildTeamFormation(
            //           matchData.awayTeam.name,
            //           matchData.awayTeam.formation,
            //           matchData.awayTeam.logo,
            //           Colors.red,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // SizedBox(height: DynamicSize.medium(context)),

            // Field + Players - Enhanced Layout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 0.68,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Group players by line for smart positioning
                    final homePlayersByLine = _groupPlayersByLine(homeStarting);
                    final awayPlayersByLine = _groupPlayersByLine(awayStarting);

                    return Stack(
                      children: [
                        // Field background - Custom painted
                        // FootballField(
                        //   width: constraints.maxWidth,
                        //   height: constraints.maxHeight,
                        //   fieldColor: const Color(0xFF2D7A3E), // Dark green
                        //   lineColor: Colors.white,
                        //   grassStripeColor: const Color(0xFF258535), // Lighter green
                        //   lineWidth: 2.0,
                        //   showStripes: true,
                        // ),
                        FootballField(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          // That's it! Auto-detects theme!
                        ),

                        // Home team players (bottom half)
                        ...homeStarting.map((player) =>
                            _buildPlayer(
                              context,
                              player,
                              constraints,
                              homePlayersByLine,
                              isHomeTeam: true,
                              teamColor: Colors.blue,
                            )),

                        // Away team players (top half)
                        ...awayStarting.map((player) =>
                            _buildPlayer(
                              context,
                              player,
                              constraints,
                              awayPlayersByLine,
                              isHomeTeam: false,
                              teamColor: Colors.red,
                            )),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Substitutes Section
            SizedBox(height: DynamicSize.medium(context)),
            Text(
              'Substitutes',
              style: STextTheme.headLineBold().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DynamicSize.small(context)),

            // Home Substitutes
            if (matchData.homeTeam.substitutes.isNotEmpty)
              _buildSubstituteSection(
                matchData.homeTeam.name,
                matchData.homeTeam.substitutes,
                Colors.blue,
              ),

            // Away Substitutes
            if (matchData.awayTeam.substitutes.isNotEmpty)
              _buildSubstituteSection(
                matchData.awayTeam.name,
                matchData.awayTeam.substitutes,
                Colors.red,
              ),

            SizedBox(height: DynamicSize.medium(context)),
          ],
        ),
      );
    });
  }

  Widget _buildTeamFormation(String teamName, String formation, String logo, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              logo,
              height: 32,
              width: 32,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.shield, size: 32, color: color);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: STextTheme.headLineBold().copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formation ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to count players in each line
  Map<int, List<Player>> _groupPlayersByLine(List<Player> players) {
    final Map<int, List<Player>> grouped = {};
    for (var player in players) {
      if (player.gridPosition != null) {
        final line = player.gridPosition!.line;
        grouped[line] = grouped[line] ?? [];
        grouped[line]!.add(player);
      }
    }
    return grouped;
  }

  Widget _buildPlayer(
      BuildContext context,
      Player player,
      BoxConstraints constraints,
      Map<int, List<Player>> playersByLine, {
        required bool isHomeTeam,
        required Color teamColor,
      }) {
    if (player.gridPosition == null) return const SizedBox.shrink();

    final gridLine = player.gridPosition!.line;
    final gridPos = player.gridPosition!.position;

    // Calculate vertical position with proper spacing
    double topPosition;
    if (isHomeTeam) {
      // Home team: bottom half
      topPosition = constraints.maxHeight * (0.96 - ((gridLine - 1) * 0.16));
    } else {
      // Away team: top half
      topPosition = constraints.maxHeight * (0.04 + ((gridLine - 1) * 0.16));
    }

    // Calculate horizontal position with smart distribution
    double leftPosition;

    // Get all players in this line
    final playersInLine = playersByLine[gridLine] ?? [];
    final playerCount = playersInLine.length;

    // Find the index of this player in the sorted line
    final sortedPlayers = List<Player>.from(playersInLine)
      ..sort((a, b) => (a.gridPosition?.position ?? 0).compareTo(b.gridPosition?.position ?? 0));
    final playerIndex = sortedPlayers.indexWhere((p) => p.id == player.id);

    // Dynamic positioning based on number of players in line
    if (playerCount == 1) {
      // Single player - center
      leftPosition = constraints.maxWidth * 0.5;
    } else if (playerCount == 2) {
      // Two players - left and right
      leftPosition = constraints.maxWidth * (playerIndex == 0 ? 0.33 : 0.67);
    } else if (playerCount == 3) {
      // Three players - left, center, right
      final positions = [0.25, 0.5, 0.75];
      leftPosition = constraints.maxWidth * positions[playerIndex];
    } else if (playerCount == 4) {
      // Four players - evenly distributed
      final positions = [0.15, 0.38, 0.62, 0.85];
      leftPosition = constraints.maxWidth * positions[playerIndex];
    } else {
      // 5+ players - distribute evenly
      final spacing = 1.0 / (playerCount + 1);
      leftPosition = constraints.maxWidth * (spacing * (playerIndex + 1));
    }

    return Positioned(
      top: topPosition,
      left: leftPosition,
      child: Transform.translate(
        offset: const Offset(-20, -36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player Image with cleaner design
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: teamColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  player.image ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Icon(
                          Icons.person,
                          size: 26,
                          color: teamColor.withOpacity(0.6)
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Player Name Card - Cleaner design like Figma
            Container(
              constraints: const BoxConstraints(maxWidth: 65),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Jersey Number
                  Text(
                    '${player.jerseyNumber}',
                    style: STextTheme.headLineBold().copyWith(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2.5),
                  // Player Last Name
                  Flexible(
                    child: Text(
                      _getLastName(player.name),
                      style: STextTheme.headLineBold().copyWith(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to extract last name
  String _getLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.length > 1 ? parts.last : fullName;
  }

  Widget _buildSubstituteSection(String teamName, List<Player> substitutes, Color teamColor) {
    if (substitutes.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: teamColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                teamName,
                style: STextTheme.headLineBold().copyWith(
                  fontSize: 14,
                  color: teamColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: substitutes.length,
            itemBuilder: (context, index) =>
                _buildSubstitutionCard(substitutes[index], teamColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSubstitutionCard(Player sub, Color teamColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Player Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: teamColor, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  sub.image ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person, size: 24, color: teamColor);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name,
                    style: STextTheme.headLineBold().copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: teamColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#${sub.jerseyNumber}',
                          style: TextStyle(
                            fontSize: 11,
                            color: teamColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sub.position,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}