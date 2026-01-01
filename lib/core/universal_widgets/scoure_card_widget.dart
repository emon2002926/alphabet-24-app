import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../theme/SColor.dart';
import '../theme/text_theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Note: Update these imports to match your project structure
// import 'package:your_app/controllers/football_live_match_controller.dart';
// import 'package:your_app/screens/match_details_screen.dart';
// import 'package:your_app/theme/s_text_theme.dart';
// import 'package:your_app/theme/s_color.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Note: Update these imports to match your project structure
// import 'package:your_app/controllers/football_live_match_controller.dart';
// import 'package:your_app/screens/match_details_screen.dart';
// import 'package:your_app/theme/s_text_theme.dart';
// import 'package:your_app/theme/s_color.dart';

class ScoureCardWidget extends StatelessWidget {
  final int index;

  const ScoureCardWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final liveMatchController = Get.find<FootballLiveMatchController>();

    return Obx(() {
      final matches = liveMatchController.displayMatches;

      if (index >= matches.length) {
        return const SizedBox.shrink();
      }

      final match = matches[index];

      // ===== SAFE PERIOD CHECK =====
      final hasPeriod = match.periods.isNotEmpty;
      final periodMinutes = hasPeriod ? match.periods[0].minutes : 0;

      // ===== PREDICTION VALUES =====
      final full = match.predictions.fulltimeResult;
      final homeProb = full.homeWin.toDouble();
      final drawProb = full.draw.toDouble();
      final awayProb = full.awayWin.toDouble();

      final overProb = match.predictions.overUnder25.over;
      final underProb = match.predictions.overUnder25.under;

      return GestureDetector(
        onTap: () => Get.to(
          MatchDetailsScreen(),
          arguments: {'matchId': match.id},
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Get.theme.brightness == Brightness.dark
                ? const Color(0xFF3E3E3E)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== TOP ROW: MINUTE/TIME & FAVORITE =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live minute or start time
                    if (match.status.isLive && hasPeriod)
                      Text(
                        "$periodMinutes'",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      )
                    else
                      Text(
                        DateFormat('HH:mm').format(match.startingAt),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SColor.primary,
                        ),
                      ),
                    // Favorite button
                    GestureDetector(
                      onTap: () => liveMatchController.toggleFavorite(index),
                      child: Icon(
                        match.isFavoriteMatch
                            ? Icons.star
                            : Icons.star_border,
                        color: match.isFavoriteMatch
                            ? Colors.amber
                            : Colors.grey[400],
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ===== HOME TEAM ROW =====
                _buildTeamRow(
                  logo: match.homeTeam.logo,
                  name: match.homeTeam.name,
                  score: match.homeTeam.score,
                  isLive: match.status.isLive,
                ),

                const SizedBox(height: 4),

                // ===== AWAY TEAM ROW =====
                _buildTeamRow(
                  logo: match.awayTeam.logo,
                  name: match.awayTeam.name,
                  score: match.awayTeam.score,
                  isLive: match.status.isLive,
                ),

                const SizedBox(height: 8),

                // ===== PREDICTION BOXES (1, X, 2) =====
                SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      // Home Win (1)
                      Expanded(
                        flex: homeProb.round().clamp(1, 100),
                        child: _buildPredictionBox(
                          label: '1',
                          percentage: homeProb,
                          color: const Color(0xFF00A9E0),
                        ),
                      ),
                      const SizedBox(width: 3),
                      // Draw (X)
                      Expanded(
                        flex: drawProb.round().clamp(1, 100),
                        child: _buildPredictionBox(
                          label: 'X',
                          percentage: drawProb,
                          color: const Color(0xFFCFD8DC),
                          textColor: Colors.black87,
                          percentageColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 3),
                      // Away Win (2)
                      Expanded(
                        flex: awayProb.round().clamp(1, 100),
                        child: _buildPredictionBox(
                          label: '2',
                          percentage: awayProb,
                          color: const Color(0xFF1A2530),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // ===== OVER/UNDER 2.5 BOXES =====
                SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      // Over 2.5
                      Expanded(
                        child: _buildOverUnderBox(
                          label: 'Over 2.5',
                          percentage: overProb,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Under 2.5
                      Expanded(
                        child: _buildOverUnderBox(
                          label: 'Under 2.5',
                          percentage: underProb,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTeamRow({
    required String logo,
    required String name,
    required int score,
    required bool isLive,
  }) {
    return Row(
      children: [
        // Team logo
        Image.network(
          logo,
          height: 20,
          width: 20,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sports_soccer,
            size: 20,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        // Team name
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Get.theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Score
        Text(
          isLive ? score.toString() : '-',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Get.theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionBox({
    required String label,
    required double percentage,
    required Color color,
    Color textColor = Colors.white,
    Color? percentageColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: percentageColor ?? textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverUnderBox({
    required String label,
    required double percentage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.brightness == Brightness.dark
            ? const Color(0xFF4A4A4A)
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Get.theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF00897B),
            ),
          ),
        ],
      ),
    );
  }
}