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
              Text('Loading predictions...', style: STextTheme.subHeadLine()),
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
              Text("No predictions available", style: STextTheme.headLineBold()),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 1. FULLTIME RESULT PROBABILITY =====
            _buildFulltimeResultSection(data.predictions.fulltimeResult, isDark),
            SizedBox(height: 16),

            // ===== 2. OVER/UNDER PROBABILITY (Grouped) =====
            _buildGroupedOverUnderSection(data.predictions, isDark),
            SizedBox(height: 16),

            // ===== 3. CORRECT SCORE PROBABILITY =====
            _buildCorrectScoreSection(data.predictions.correctScores.top10, isDark),
            SizedBox(height: 16),

            // ===== 4. BOTH TEAMS TO SCORE =====
            _buildBTTSSection(data.predictions.bothTeamsToScore, isDark),
            SizedBox(height: 16),

            // ===== 5. TEAM TO SCORE FIRST =====
            if (data.predictions.teamToScoreFirst != null)
              _buildThreeWaySection(
                'TEAM TO SCORE FIRST PROBABILITY',
                'Home', data.predictions.teamToScoreFirst!.home,
                'Draw', data.predictions.teamToScoreFirst!.draw,
                'Away', data.predictions.teamToScoreFirst!.away,
                isDark,
              ),
            if (data.predictions.teamToScoreFirst != null) SizedBox(height: 16),

            // ===== 6. FIRST HALF WINNER =====
            if (data.predictions.firstHalfWinner != null)
              _buildThreeWaySection(
                'FIRST HALF WINNER PROBABILITY',
                'Home', data.predictions.firstHalfWinner!.home,
                'Draw', data.predictions.firstHalfWinner!.draw,
                'Away', data.predictions.firstHalfWinner!.away,
                isDark,
              ),
            if (data.predictions.firstHalfWinner != null) SizedBox(height: 16),

            // ===== 7. DOUBLE CHANCE PROBABILITY =====
            _buildDoubleChanceSection(data.predictions.doubleChance, isDark),
            SizedBox(height: 16),

            // ===== 8. HALF TIME/FULL TIME PROBABILITY =====
            _buildHalfTimeFullTimeSection(data.predictions.halfTimeFullTime, isDark),
            SizedBox(height: 16),

            // ===== 9. HOME OVER/UNDER (Grouped) =====
            if (data.predictions.availableHomeOverUnder.isNotEmpty)
              _buildGroupedTeamOverUnderSection(
                'HOME OVER/UNDER PROBABILITY',
                data.predictions.availableHomeOverUnder,
                isDark,
              ),
            if (data.predictions.availableHomeOverUnder.isNotEmpty) SizedBox(height: 16),

            // ===== 10. AWAY OVER/UNDER (Grouped) =====
            if (data.predictions.availableAwayOverUnder.isNotEmpty)
              _buildGroupedTeamOverUnderSection(
                'AWAY OVER/UNDER PROBABILITY',
                data.predictions.availableAwayOverUnder,
                isDark,
              ),
            if (data.predictions.availableAwayOverUnder.isNotEmpty) SizedBox(height: 16),

            // ===== 11. CORNERS OVER/UNDER (Grouped) =====
            if (data.predictions.availableCornersPredictions.isNotEmpty)
              _buildGroupedCornersSection(
                data.predictions.availableCornersPredictions,
                isDark,
              ),

            SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // ===== SECTION HEADER =====
  Widget _buildSectionHeader(String title) {
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ===== TWO-WAY PROGRESS BAR =====
  Widget _buildTwoWayProgressBar({
    required String label1,
    required double value1,
    required String label2,
    required double value2,
    required bool isDark,
    Color? color1,
    Color? color2,
  }) {
    color1 ??= SColor.primary;
    color2 ??= Color(0xFF1E3A5F);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label1 ${value1.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              '$label2 ${value2.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Expanded(
                flex: value1.toInt().clamp(1, 100),
                child: Container(height: 10, color: color1),
              ),
              Expanded(
                flex: value2.toInt().clamp(1, 100),
                child: Container(height: 10, color: color2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===== THREE-WAY PROGRESS BAR =====
  Widget _buildThreeWayProgressBar({
    required String label1,
    required double value1,
    required String label2,
    required double value2,
    required String label3,
    required double value3,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label1 ${value1.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              '$label2 ${value2.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Expanded(
                flex: value1.toInt().clamp(1, 100),
                child: Container(height: 10, color: SColor.primary),
              ),
              Expanded(
                flex: value2.toInt().clamp(1, 100),
                child: Container(height: 10, color: Color(0xFF9CA3AF)),
              ),
              Expanded(
                flex: value3.toInt().clamp(1, 100),
                child: Container(height: 10, color: Color(0xFF1E3A5F)),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            '$label3 ${value3.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ===== 1. FULLTIME RESULT =====
  Widget _buildFulltimeResultSection(FullTimeResult result, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader('FULLTIME RESULT PROBABILITY'),
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildThreeWayProgressBar(
              label1: 'Home',
              value1: result.homeWin,
              label2: 'Draw',
              value2: result.draw,
              label3: 'Away',
              value3: result.awayWin,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ===== 2. GROUPED OVER/UNDER =====
// ===== 2. GROUPED OVER/UNDER =====
  Widget _buildGroupedOverUnderSection(PredictionsData predictions, bool isDark) {
    final overUnderList = [
      {'label': '1.5', 'over': predictions.overUnder15.over, 'under': predictions.overUnder15.under},
      {'label': '2.5', 'over': predictions.overUnder25.over, 'under': predictions.overUnder25.under},
      {'label': '3.5', 'over': predictions.overUnder35.over, 'under': predictions.overUnder35.under},
      {'label': '4.5', 'over': predictions.overUnder45.over, 'under': predictions.overUnder45.under},
    ];

    // Filter out items where both values are 0
    final validItems = overUnderList.where((item) =>
    (item['over'] as double) > 0 || (item['under'] as double) > 0
    ).toList();

    if (validItems.isEmpty) return SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Main header
          _buildSectionHeader('OVER/UNDER PROBABILITY'),

          // Sub-sections for each over/under
          ...validItems.map((item) {
            return Column(
              children: [
                // Sub-header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
                  child: Text(
                    'OVER/UNDER ${item['label']} PROBABILITY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                // Progress bar
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildTwoWayProgressBar(
                    label1: 'Yes',
                    value1: item['over'] as double,
                    label2: 'No',
                    value2: item['under'] as double,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
  // ===== 3. CORRECT SCORE =====
  Widget _buildCorrectScoreSection(List<TopScore> scores, bool isDark) {
    // Filter out "Other" scores and build grid
    final gridScores = <String, double>{};
    double otherHomeWin = 0;
    double otherAwayWin = 0;
    double otherDraw = 0;

    for (var score in scores) {
      if (score.score.startsWith('Other')) {
        if (score.score == 'Other_1') otherHomeWin = score.probability;
        if (score.score == 'Other_2') otherAwayWin = score.probability;
        if (score.score == 'Other_X') otherDraw = score.probability;
      } else {
        gridScores[score.score] = score.probability;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader('CORRECT SCORE PROBABILITY'),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Header row (columns: 0, 1, 2)
                Row(
                  children: [
                    SizedBox(width: 30),
                    for (int col = 0; col <= 2; col++)
                      Expanded(
                        child: Center(
                          child: Text(
                            '$col',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                // Score grid (rows: 0, 1, 2, 3)
                for (int row = 0; row <= 3; row++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$row',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        for (int col = 0; col <= 2; col++)
                          Expanded(
                            child: _buildScoreGridCell(
                              '$row-$col',
                              gridScores['$row-$col'],
                              row,
                              col,
                              isDark,
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 12),
                // Other scores row
                Row(
                  children: [
                    SizedBox(width: 30),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Home Win\n${otherHomeWin.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Away Win\n${otherAwayWin.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Draw\n${otherDraw.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
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

  Widget _buildScoreGridCell(String scoreKey, double? probability, int row, int col, bool isDark) {
    Color bgColor;
    if (row > col) {
      bgColor = SColor.primary.withOpacity(0.15); // Home win
    } else if (col > row) {
      bgColor = Color(0xFF3B82F6).withOpacity(0.15); // Away win
    } else {
      bgColor = Color(0xFF6B7280).withOpacity(0.15); // Draw
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            scoreKey,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            probability != null ? '${probability.toStringAsFixed(2)}%' : '-',
            style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }

  // ===== 4. BOTH TEAMS TO SCORE =====
  Widget _buildBTTSSection(BothTeamsToScore btts, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader('BOTH TEAMS TO SCORE PROBABILITY'),
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildTwoWayProgressBar(
              label1: 'Yes',
              value1: btts.yes,
              label2: 'No',
              value2: btts.no,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ===== 5 & 6. THREE-WAY SECTION (Team to Score First, First Half Winner) =====
  Widget _buildThreeWaySection(
      String title,
      String label1, double value1,
      String label2, double value2,
      String label3, double value3,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader(title),
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildThreeWayProgressBar(
              label1: label1,
              value1: value1,
              label2: label2,
              value2: value2,
              label3: label3,
              value3: value3,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ===== 7. DOUBLE CHANCE =====
  Widget _buildDoubleChanceSection(DoubleChance dc, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader('DOUBLE CHANCE PROBABILITY'),
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildThreeWayProgressBar(
              label1: 'Draw-Home',
              value1: dc.homeOrDraw,
              label2: 'Home-Away',
              value2: dc.homeOrAway,
              label3: 'Draw-Away',
              value3: dc.awayOrDraw,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ===== 8. HALF TIME/FULL TIME =====
  Widget _buildHalfTimeFullTimeSection(HalfTimeFullTime? htft, bool isDark) {
    final grid = htft?.asGrid ?? [
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
    ];
    final labels = htft?.labelsGrid ?? [
      ['HH', 'HD', 'HA'],
      ['DH', 'DD', 'DA'],
      ['AH', 'AD', 'AA'],
    ];
    final rowLabels = ['Home', 'Draw', 'Away'];
    final rowColors = [SColor.primary, Color(0xFF6B7280), Color(0xFF3B82F6)];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSectionHeader('HALF TIME/FULL TIME PROBABILITY'),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Header row with icons
                Row(
                  children: [
                    Container(width: 60, alignment: Alignment.center, child: Text('HT / FT', style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45))),
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.sports_soccer, size: 16, color: rowColors[i]),
                            Text(rowLabels[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: rowColors[i])),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                // Data rows
                for (int row = 0; row < 3; row++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: rowColors[row].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              rowLabels[row],
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: rowColors[row]),
                            ),
                          ),
                        ),
                        for (int col = 0; col < 3; col++)
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    labels[row][col],
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                                  ),
                                  Text(
                                    '${grid[row][col].toStringAsFixed(2)}%',
                                    style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45),
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

  // ===== 9 & 10. GROUPED TEAM OVER/UNDER (Home/Away) =====
  Widget _buildGroupedTeamOverUnderSection(
      String mainTitle, // "HOME OVER/UNDER PROBABILITY" or "AWAY OVER/UNDER PROBABILITY"
      List<MapEntry<String, OverUnderGoals>> items,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Main header
          _buildSectionHeader(mainTitle),

          // Sub-sections
          ...items.map((item) {
            final subTitle = mainTitle.replaceAll(' PROBABILITY', ' ${item.key} PROBABILITY');

            return Column(
              children: [
                // Sub-header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
                  child: Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildTwoWayProgressBar(
                    label1: 'Yes',
                    value1: item.value.over,
                    label2: 'No',
                    value2: item.value.under,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }


  // ===== 11. GROUPED CORNERS OVER/UNDER =====
  Widget _buildGroupedCornersSection(
      List<MapEntry<String, CornersOverUnder>> items,
      bool isDark,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Main header
          _buildSectionHeader('CORNERS OVER/UNDER PROBABILITY'),

          // Sub-sections
          ...items.map((item) {
            return Column(
              children: [
                // Sub-header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
                  child: Text(
                    'CORNERS OVER/UNDER ${item.key} PROBABILITY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildCornersProgressBar(
                    yes: item.value.yes,
                    equal: item.value.equal,
                    no: item.value.no,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
  Widget _buildCornersProgressBar({
    required double yes,
    required double equal,
    required double no,
    required bool isDark,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yes ${yes.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
            Text('No ${no.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              Expanded(flex: yes.toInt().clamp(1, 100), child: Container(height: 10, color: SColor.primary)),
              Expanded(flex: equal.toInt().clamp(1, 100), child: Container(height: 10, color: Color(0xFF9CA3AF))),
              Expanded(flex: no.toInt().clamp(1, 100), child: Container(height: 10, color: Color(0xFF1E3A5F))),
            ],
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text('Equal ${equal.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
        ),
      ],
    );
  }
}