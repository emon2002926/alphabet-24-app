
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/SColor.dart';
import '../controllers/match_lineup_controller.dart';
import '../models/match_lineup_model.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineUp extends StatefulWidget {
  final int fixtureId;

  const LineUp({super.key, required this.fixtureId});

  @override
  State<LineUp> createState() => _LineUpState();
}

class _LineUpState extends State<LineUp> {
  late final MatchLineupController controller;
  int? selectedPlayerId;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      MatchLineupController(),
      tag: 'lineup_${widget.fixtureId}',
    );
    controller.fetchLineup(widget.fixtureId);
  }

  @override
  void dispose() {
    Get.delete<MatchLineupController>(tag: 'lineup_${widget.fixtureId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
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

      if (controller.errorMessage.isNotEmpty) {
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
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchLineup(widget.fixtureId),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final MatchLineup? matchData = controller.lineupData.value;
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

      // Team colors
      final homeColor = const Color(0xFF26A69A); // Teal
      final awayColor = const Color(0xFF5C6BC0); // Indigo

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
                      homeColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTeamFormation(
                      matchData.awayTeam.name,
                      matchData.awayTeam.formation,
                      matchData.awayTeam.logo,
                      awayColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: DynamicSize.medium(context)),

            // Field + Players - WIDER ASPECT RATIO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AspectRatio(
                aspectRatio: 0.58, // Make field taller to give more vertical space
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Field background
                            CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: FootballFieldPainter(),
                            ),

                            // Away team players (top half)
                            ...awayStarting.map((player) => _buildPlayer(
                              context,
                              player,
                              constraints,
                              isHomeTeam: false,
                              teamColor: awayColor,
                            )),

                            // Home team players (bottom half)
                            ...homeStarting.map((player) => _buildPlayer(
                              context,
                              player,
                              constraints,
                              isHomeTeam: true,
                              teamColor: homeColor,
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Substitutes Section
            SizedBox(height: DynamicSize.large(context)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Substitutes',
                  style: STextTheme.headLine().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: DynamicSize.small(context)),

            // Home Substitutes
            if (matchData.homeTeam.substitutes.isNotEmpty)
              _buildSubstituteSection(
                matchData.homeTeam.name,
                matchData.homeTeam.substitutes,
                homeColor,
              ),

            // Away Substitutes
            if (matchData.awayTeam.substitutes.isNotEmpty)
              _buildSubstituteSection(
                matchData.awayTeam.name,
                matchData.awayTeam.substitutes,
                awayColor,
              ),

            SizedBox(height: DynamicSize.large(context)),
          ],
        ),
      );
    });
  }

  Widget _buildTeamFormation(
      String teamName,
      String formation,
      String logo,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.network(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.shield, color: color, size: 20);
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            teamName,
            style: STextTheme.headLine().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            formation,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getShortName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      final lastName = parts.last;
      if (lastName.length <= 10) {
        return lastName;
      }
      return '${lastName.substring(0, 8)}..';
    }
    if (fullName.length > 10) {
      return '${fullName.substring(0, 8)}..';
    }
    return fullName;
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

    // IMPROVED VERTICAL SPACING - More space between lines
    double topPosition;
    if (isHomeTeam) {
      // Home team: bottom to center
      // Start from bottom (0.92) and move up with better spacing
      final lineSpacing = 0.16; // Increased from 0.14
      topPosition = constraints.maxHeight * (0.92 - ((gridLine - 1) * lineSpacing));
    } else {
      // Away team: top to center
      // Start from top (0.08) and move down with better spacing
      final lineSpacing = 0.16; // Increased from 0.14
      topPosition = constraints.maxHeight * (0.08 + ((gridLine - 1) * lineSpacing));
    }

    // IMPROVED HORIZONTAL DISTRIBUTION
    double leftPosition;
    switch (gridPos) {
      case 1:
        leftPosition = constraints.maxWidth * 0.12; // Moved more to edge
        break;
      case 2:
        leftPosition = constraints.maxWidth * 0.35; // Better spacing
        break;
      case 3:
        leftPosition = constraints.maxWidth * 0.65; // Better spacing
        break;
      case 4:
        leftPosition = constraints.maxWidth * 0.88; // Moved more to edge
        break;
      default:
        leftPosition = constraints.maxWidth * 0.5;
    }

    final isSelected = selectedPlayerId == player.id;
    final shortName = _getShortName(player.name);

    // Only show names for edge players or selected
    final showName = isSelected || gridPos == 1 || gridPos == 4;

    return Positioned(
      top: topPosition,
      left: leftPosition,
      child: Transform.translate(
        offset: const Offset(-26, -26), // Center the 52x52 widget
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedPlayerId = isSelected ? null : player.id;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Player avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? teamColor : teamColor.withOpacity(0.8),
                    width: isSelected ? 3.5 : 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isSelected ? 0.3 : 0.2),
                      blurRadius: isSelected ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: player.image != null && player.image!.isNotEmpty
                      ? Image.network(
                    player.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 28,
                        color: teamColor.withOpacity(0.4),
                      );
                    },
                  )
                      : Icon(
                    Icons.person,
                    size: 28,
                    color: teamColor.withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // Jersey number badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: teamColor,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 3,
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
              // Show name conditionally
              if (showName)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 70),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Text(
                      shortName,
                      style: STextTheme.headLine().copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubstituteSection(
      String teamName,
      List<Player> substitutes,
      Color teamColor,
      ) {
    if (substitutes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 16,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...substitutes.map((sub) => _buildSubstituteCard(sub, teamColor)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSubstituteCard(Player sub, Color teamColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: teamColor, width: 2),
            ),
            child: ClipOval(
              child: sub.image != null && sub.image!.isNotEmpty
                  ? Image.network(
                sub.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, color: teamColor, size: 24);
                },
              )
                  : Icon(Icons.person, color: teamColor, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: STextTheme.headLine().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${sub.position} • #${sub.jerseyNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FootballFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fieldPaint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fieldPaint,
    );

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      linePaint,
    );

    // Center dot
    final centerDotPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      3,
      centerDotPaint,
    );

    // Penalty boxes
    final penaltyBoxWidth = size.width * 0.7;
    final penaltyBoxHeight = size.height * 0.18;
    final goalAreaWidth = size.width * 0.45;
    final goalAreaHeight = size.height * 0.09;

    // Top penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        0,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      linePaint,
    );

    // Top goal area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalAreaWidth) / 2,
        0,
        goalAreaWidth,
        goalAreaHeight,
      ),
      linePaint,
    );

    // Bottom penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        size.height - penaltyBoxHeight,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      linePaint,
    );

    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalAreaWidth) / 2,
        size.height - goalAreaHeight,
        goalAreaWidth,
        goalAreaHeight,
      ),
      linePaint,
    );

    // Penalty arcs
    final arcRadius = size.width * 0.13;
    final arcRect = Rect.fromCircle(
      center: Offset(size.width / 2, penaltyBoxHeight),
      radius: arcRadius,
    );
    canvas.drawArc(arcRect, 0, 3.14159, false, linePaint);

    final arcRect2 = Rect.fromCircle(
      center: Offset(size.width / 2, size.height - penaltyBoxHeight),
      radius: arcRadius,
    );
    canvas.drawArc(arcRect2, 3.14159, 3.14159, false, linePaint);

    // Penalty spots
    canvas.drawCircle(
      Offset(size.width / 2, penaltyBoxHeight * 0.55),
      3,
      centerDotPaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height - (penaltyBoxHeight * 0.55)),
      3,
      centerDotPaint,
    );

    // Corner arcs
    final cornerRadius = size.width * 0.07;

    canvas.drawArc(
      Rect.fromLTWH(-cornerRadius, -cornerRadius, cornerRadius * 2, cornerRadius * 2),
      0,
      1.5708,
      false,
      linePaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(size.width - cornerRadius, -cornerRadius, cornerRadius * 2, cornerRadius * 2),
      1.5708,
      1.5708,
      false,
      linePaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(-cornerRadius, size.height - cornerRadius, cornerRadius * 2, cornerRadius * 2),
      4.71239,
      1.5708,
      false,
      linePaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(size.width - cornerRadius, size.height - cornerRadius, cornerRadius * 2, cornerRadius * 2),
      3.14159,
      1.5708,
      false,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}