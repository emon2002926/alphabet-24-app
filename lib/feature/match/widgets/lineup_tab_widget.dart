
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/match_lineup_controller.dart';
import '../models/match_lineup_model.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';

class LineUp extends StatelessWidget {
  final int fixtureId;

  LineUp({super.key, required this.fixtureId});

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
                style: STextTheme.headLine().copyWith(fontSize: 18),
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

            // Formation Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTeamFormation(
                      matchData.homeTeam.name,
                      matchData.homeTeam.formation,
                      matchData.homeTeam.logo,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTeamFormation(
                      matchData.awayTeam.name,
                      matchData.awayTeam.formation,
                      matchData.awayTeam.logo,
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: DynamicSize.medium(context)),

            // Field + Players
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 0.68,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Field background
                        Image.asset(
                          'assets/images/field.png',
                          fit: BoxFit.fill,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        ),

                        // Home team players (bottom half)
                        ...homeStarting.map((player) =>
                            _buildPlayer(
                              context,
                              player,
                              constraints,
                              isHomeTeam: true,
                              teamColor: Colors.blue,
                            )),

                        // Away team players (top half)
                        ...awayStarting.map((player) =>
                            _buildPlayer(
                              context,
                              player,
                              constraints,
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
              style: STextTheme.headLine().copyWith(
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
                  style: STextTheme.headLine().copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formation,
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

  Widget _buildPlayer(
      BuildContext context,
      Player player,
      BoxConstraints constraints, {
        required bool isHomeTeam,
        required Color teamColor,
      }) {
    if (player.gridPosition == null) return const SizedBox.shrink();

    final gridLine = player.gridPosition!.line;
    final gridPos = player.gridPosition!.position;

    // Calculate vertical position
    double topPosition;
    if (isHomeTeam) {
      // Home team: bottom half
      // line 1 = bottom (near home goal), line 5 = center
      topPosition = constraints.maxHeight * (1.0 - ((gridLine - 1) / 8.0));
    } else {
      // Away team: top half
      // line 1 = top (near away goal), line 5 = center
      topPosition = constraints.maxHeight * ((gridLine - 1) / 8.0);
    }

    // Calculate horizontal position
    double leftPosition;
    if (gridPos == 1) {
      leftPosition = constraints.maxWidth * 0.15;
    } else if (gridPos == 2) {
      leftPosition = constraints.maxWidth * 0.38;
    } else if (gridPos == 3) {
      leftPosition = constraints.maxWidth * 0.62;
    } else {
      leftPosition = constraints.maxWidth * 0.85;
    }

    return Positioned(
      top: topPosition,
      left: leftPosition,
      child: Transform.translate(
        offset: const Offset(-25, -40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: teamColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
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
                    return Icon(Icons.person, size: 32, color: teamColor);
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Jersey Number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: teamColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${player.jerseyNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Player Name
            Container(
              constraints: const BoxConstraints(maxWidth: 90),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                player.name,
                style: STextTheme.headLine().copyWith(fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
                style: STextTheme.headLine().copyWith(
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
                    style: STextTheme.headLine().copyWith(fontSize: 13),
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