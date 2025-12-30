import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/match/controllers/summary_controller.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/universal_widgets/s_progress_widget.dart';
import '../models/summary_model.dart';

class PredictionsTabWidgets extends StatelessWidget {
  final int id;
  const PredictionsTabWidgets({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final summaryController = Get.put(SummaryController());
    summaryController.fetchSummary(id.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (summaryController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      }

      final summaryData = summaryController.summaryData.value;
      if (summaryData == null) {
        return Center(
          child: Text(
            "No data available",
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      final predictions = summaryData.predictions;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // Match Result Section
            _buildSectionHeader('MATCH RESULT', context),
            SizedBox(height: DynamicSize.small(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: _buildMatchResultCard(
                predictions.fulltimeResult,
                summaryData.summary.homeTeam.name,
                summaryData.summary.awayTeam.name,
                isDark,
                context,
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),

            // Correct Score Prediction
            _buildSectionHeader('CORRECT SCORE PREDICTION', context),
            SizedBox(height: DynamicSize.small(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: _buildCorrectScoreTable(
                predictions.correctScores.top5,
                isDark,
                context,
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),

            // Both Teams To Score
            _buildSectionHeader('BOTH TEAMS TO SCORE', context),
            SizedBox(height: DynamicSize.small(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: _buildSimpleProgressCard(
                'Both Teams Score',
                predictions.bothTeamsToScore.yes,
                predictions.bothTeamsToScore.no,
                'Yes',
                'No',
                isDark,
                context,
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),

            // Over/Under 2.5
            _buildSectionHeader('OVER / UNDER 2.5 GOALS', context),
            SizedBox(height: DynamicSize.small(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: _buildSimpleProgressCard(
                'Total Goals',
                predictions.overUnder25.over,
                predictions.overUnder25.under,
                'Over 2.5',
                'Under 2.5',
                isDark,
                context,
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),

            // Double Chance
            _buildSectionHeader('DOUBLE CHANCE', context),
            SizedBox(height: DynamicSize.small(context)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: Column(
                children: [
                  _buildDoubleChanceCard(
                    'Home or Draw',
                    predictions.doubleChance.homeOrDraw,
                    isDark,
                    context,
                  ),
                  SizedBox(height: DynamicSize.small(context)),
                  _buildDoubleChanceCard(
                    'Away or Draw',
                    predictions.doubleChance.awayOrDraw,
                    isDark,
                    context,
                  ),
                  SizedBox(height: DynamicSize.small(context)),
                  _buildDoubleChanceCard(
                    'Home or Away',
                    predictions.doubleChance.homeOrAway,
                    isDark,
                    context,
                  ),
                ],
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: Text(
        title,
        style: STextTheme.headLine().copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMatchResultCard(
      FullTimeResult result,
      String homeName,
      String awayName,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      padding: EdgeInsets.all(DynamicSize.medium(context)),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildResultOption(
                  homeName,
                  result.homeWin,
                  isDark,
                  context,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildResultOption(
                  'Draw',
                  result.draw,
                  isDark,
                  context,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildResultOption(
                  awayName,
                  result.awayWin,
                  isDark,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultOption(
      String label,
      double percentage,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: DynamicSize.small(context),
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: STextTheme.headLine().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: STextTheme.subHeadLine().copyWith(
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectScoreTable(
      List<TopScore> scores,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: DynamicSize.small(context),
              horizontal: DynamicSize.medium(context),
            ),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '#',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Score',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'Probability',
                  style: STextTheme.headLine().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ...List.generate(scores.length, (index) {
            final score = scores[index];
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: DynamicSize.small(context),
                horizontal: DynamicSize.medium(context),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: SColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: STextTheme.headLine().copyWith(
                          fontSize: 12,
                          color: SColor.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      score.score,
                      style: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${score.probability.toStringAsFixed(1)}%',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSimpleProgressCard(
      String title,
      double leftValue,
      double rightValue,
      String leftLabel,
      String rightLabel,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      padding: EdgeInsets.all(DynamicSize.medium(context)),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                rightLabel,
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SProgressWidget(
            label: title,
            homeValue: '${leftValue.toStringAsFixed(0)}%',
            awayValue: '${rightValue.toStringAsFixed(0)}%',
            homePercentage: leftValue,
            awayPercentage: rightValue,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDoubleChanceCard(
      String label,
      double percentage,
      bool isDark,
      BuildContext context,
      ) {
    return Container(
      padding: EdgeInsets.all(DynamicSize.medium(context)),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: STextTheme.subHeadLine().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: STextTheme.headLine().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: SColor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}