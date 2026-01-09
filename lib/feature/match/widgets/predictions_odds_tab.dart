import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/predictionscontroller.dart';
import '../models/predictions_odds_response.dart';




class PredictionsOddsTab extends StatelessWidget {
  final int fixtureId;
  const PredictionsOddsTab({super.key, required this.fixtureId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PredictionsOddsController());
    controller.fetchPredictionsOdds(fixtureId.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: SColor.primary),
              SizedBox(height: 16),
              Text(
                'Loading predictions...',
                style: STextTheme.subHeadLine(),
              ),
            ],
          ),
        );
      }

      final data = controller.predictionsOddsData.value;
      if (data == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 60, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                "No predictions available",
                style: STextTheme.headLine(),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 1. MATCH RESULT PROBABILITIES =====
            _buildMatchResultProbabilities(
              data.predictions.fulltimeResult,
              isDark,
              context,
            ),

            SizedBox(height: 20),

            // ===== 2. OVER/UNDER PROBABILITY (Multiple) =====
            _buildOverUnderProbabilitySection(data.predictions, isDark, context),

            SizedBox(height: 20),

            // ===== 3. CORRECT SCORE PROBABILITY =====
            _buildCorrectScoreProbability(
              data.predictions.correctScores.top10,
              isDark,
              context,
            ),

            SizedBox(height: 20),

            // ===== 4. DOUBLE CHANCE PROBABILITY =====
            _buildDoubleChanceProbability(
              data.predictions.doubleChance,
              isDark,
              context,
            ),

            SizedBox(height: 20),

            // ===== 5. HALF TIME / FULL TIME PROBABILITY =====
            _buildHalfTimeFullTimeProbability(isDark, context),

            SizedBox(height: 20),

            // ===== 6. BTTS (BOTH TEAMS TO SCORE) =====
            _buildBTTSSection(data.predictions, isDark, context),

            SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // ===== SECTION HEADER =====
  Widget _buildSectionHeader(String title, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1A2B4A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ===== MATCH RESULT PROBABILITIES =====
  Widget _buildMatchResultProbabilities(
      FullTimeResult result,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader('MATCH RESULT PROBABILITIES', isDark),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Top row: Home label positioned over home section, Draw on far right
                Row(
                  children: [
                    // Home label - positioned to align with home bar section
                    Expanded(
                      flex: result.homeWin.toInt().clamp(1, 100),
                      child: Center(
                        child: Text(
                          'Home ${result.homeWin.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Spacer for draw + away sections
                    Expanded(
                      flex: (result.draw.toInt() + result.awayWin.toInt()).clamp(1, 100),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Draw ${result.draw.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: result.homeWin.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: SColor.primary,
                        ),
                      ),
                      Expanded(
                        flex: result.draw.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      Expanded(
                        flex: result.awayWin.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Bottom row: Away label centered
                Center(
                  child: Text(
                    'Away ${result.awayWin.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== CORRECT SCORE PROBABILITY =====
  Widget _buildCorrectScoreProbability(
      List<TopScore> scores,
      bool isDark,
      BuildContext context,
      ) {
    // Separate scores into Home Win, Away Win, and Draw categories
    List<TopScore> homeWinScores = [];
    List<TopScore> awayWinScores = [];
    List<TopScore> drawScores = [];

    for (var score in scores) {
      final parts = score.score.split('-');
      if (parts.length == 2) {
        final home = int.tryParse(parts[0]) ?? 0;
        final away = int.tryParse(parts[1]) ?? 0;
        if (home > away) {
          homeWinScores.add(score);
        } else if (away > home) {
          awayWinScores.add(score);
        } else {
          drawScores.add(score);
        }
      }
    }

    // Sort each category by probability
    homeWinScores.sort((a, b) => b.probability.compareTo(a.probability));
    awayWinScores.sort((a, b) => b.probability.compareTo(a.probability));
    drawScores.sort((a, b) => b.probability.compareTo(a.probability));

    // Take top 4 from each category
    homeWinScores = homeWinScores.take(4).toList();
    awayWinScores = awayWinScores.take(4).toList();
    drawScores = drawScores.take(4).toList();

    // Calculate totals
    double homeTotal = homeWinScores.fold(0, (sum, s) => sum + s.probability);
    double awayTotal = awayWinScores.fold(0, (sum, s) => sum + s.probability);
    double drawTotal = drawScores.fold(0, (sum, s) => sum + s.probability);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader('CORRECT SCORE PROBABILITY', isDark),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Column headers
                Row(
                  children: [
                    SizedBox(width: 30), // Empty space for rank
                    Expanded(
                      child: Center(
                        child: Text(
                          'Home Win',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Away Win',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Draw',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Score rows
                for (int i = 0; i < 4; i++)
                  _buildScoreRow(
                    i + 1,
                    i < homeWinScores.length ? homeWinScores[i] : null,
                    i < awayWinScores.length ? awayWinScores[i] : null,
                    i < drawScores.length ? drawScores[i] : null,
                    isDark,
                  ),
                SizedBox(height: 8),
                Divider(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
                SizedBox(height: 8),
                // Totals row
                Row(
                  children: [
                    SizedBox(width: 30),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Home Win\n${homeTotal.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Away Win\n${awayTotal.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Draw\n${drawTotal.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
      int rank,
      TopScore? homeScore,
      TopScore? awayScore,
      TopScore? drawScore,
      bool isDark,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: _buildScoreCell(homeScore, SColor.primary, isDark),
          ),
          Expanded(
            child: _buildScoreCell(awayScore, Color(0xFF3B82F6), isDark),
          ),
          Expanded(
            child: _buildScoreCell(drawScore, Color(0xFF6B7280), isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCell(TopScore? score, Color color, bool isDark) {
    if (score == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF334155).withOpacity(0.3) : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : Colors.black26,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            score.score,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            '${score.probability.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ===== DOUBLE CHANCE PROBABILITY =====
  Widget _buildDoubleChanceProbability(
      DoubleChance doubleChance,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader('DOUBLE CHANCE PROBABILITY', isDark),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Labels row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Draw-Home ${doubleChance.homeOrDraw.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      'Home-Away ${doubleChance.homeOrAway.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: doubleChance.homeOrDraw.toInt(),
                        child: Container(
                          height: 10,
                          color: SColor.primary,
                        ),
                      ),
                      Expanded(
                        flex: doubleChance.homeOrAway.toInt(),
                        child: Container(
                          height: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Expanded(
                        flex: doubleChance.awayOrDraw.toInt(),
                        child: Container(
                          height: 10,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Bottom label
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Draw-Away ${doubleChance.awayOrDraw.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== HALF TIME / FULL TIME PROBABILITY =====
  Widget _buildHalfTimeFullTimeProbability(bool isDark, BuildContext context) {
    // Sample data - you'll need to add this to your model if API provides it
    final htftData = [
      ['Home', '1/1', '1/X', '1/2'],
      ['Draw', 'X/1', 'X/X', 'X/2'],
      ['Away', '2/1', '2/X', '2/2'],
    ];

    // Sample percentages - replace with actual data
    final percentages = [
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader('HALF TIME/FULL TIME PROBABILITY', isDark),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    SizedBox(width: 60), // HT label space
                    Expanded(
                      child: Center(
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: SColor.primary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Draw',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Away',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Data rows
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: i == 0
                                ? SColor.primary.withOpacity(0.1)
                                : i == 1
                                ? Color(0xFF6B7280).withOpacity(0.1)
                                : Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              htftData[i][0],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: i == 0
                                    ? SColor.primary
                                    : i == 1
                                    ? Color(0xFF6B7280)
                                    : Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        for (int j = 0; j < 3; j++)
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Color(0xFF334155)
                                    : Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    htftData[i][j + 1],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${percentages[i][j].toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== OVER/UNDER PROBABILITY SECTION =====
  Widget _buildOverUnderProbabilitySection(
      PredictionsData predictions,
      bool isDark,
      BuildContext context,
      ) {
    // Build list of over/under data
    // Currently only 2.5 is available from API, but structured for easy expansion
    final overUnderItems = <Map<String, dynamic>>[
      // Uncomment when API provides these:
      // {'label': '1.5', 'yes': predictions.overUnder15?.over ?? 0, 'no': predictions.overUnder15?.under ?? 0},
      {'label': '2.5', 'yes': predictions.overUnder25.over, 'no': predictions.overUnder25.under},
      // {'label': '3.5', 'yes': predictions.overUnder35?.over ?? 0, 'no': predictions.overUnder35?.under ?? 0},
      // {'label': '4.5', 'yes': predictions.overUnder45?.over ?? 0, 'no': predictions.overUnder45?.under ?? 0},
    ];

    return Column(
      children: overUnderItems.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildOverUnderCard(
            'OVER/UNDER ${item['label']} PROBABILITY',
            item['yes'] as double,
            item['no'] as double,
            isDark,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverUnderCard(
      String title,
      double yesValue,
      double noValue,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader(title, isDark),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Top: Yes label on the left side (above yes portion)
                Row(
                  children: [
                    Expanded(
                      flex: yesValue.toInt().clamp(1, 100),
                      child: Center(
                        child: Text(
                          'Yes ${yesValue.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: noValue.toInt().clamp(1, 100),
                      child: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: yesValue.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: SColor.primary,
                        ),
                      ),
                      Expanded(
                        flex: noValue.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Bottom: No label on the right
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'No ${noValue.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== BTTS (BOTH TEAMS TO SCORE) SECTION =====
  Widget _buildBTTSSection(
      PredictionsData predictions,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildSectionHeader('BOTH TEAMS TO SCORE PROBABILITY', isDark),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Top: Yes label
                Row(
                  children: [
                    Expanded(
                      flex: predictions.bothTeamsToScore.yes.toInt().clamp(1, 100),
                      child: Center(
                        child: Text(
                          'Yes ${predictions.bothTeamsToScore.yes.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: predictions.bothTeamsToScore.no.toInt().clamp(1, 100),
                      child: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: predictions.bothTeamsToScore.yes.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: SColor.primary,
                        ),
                      ),
                      Expanded(
                        flex: predictions.bothTeamsToScore.no.toInt().clamp(1, 100),
                        child: Container(
                          height: 10,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Bottom: No label
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'No ${predictions.bothTeamsToScore.no.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
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