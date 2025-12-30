import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/size_const/dynamic_size.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // ===== MATCH HEADER =====
            _buildMatchHeader(data.fixture, isDark, context),

            SizedBox(height: DynamicSize.large(context)),

            // ===== MATCH OUTCOME SECTION =====
            _buildSectionTitle('Match Outcome', Icons.sports_soccer, isDark, context),
            SizedBox(height: DynamicSize.small(context)),
            _buildMatchOutcomeCards(
              data.predictions.fulltimeResult,
              data.fixture.homeTeam.name,
              data.fixture.awayTeam.name,
              isDark,
              context,
            ),

            SizedBox(height: DynamicSize.large(context)),

            // ===== BETTING ODDS (IF AVAILABLE) =====
            if (data.odds.preMatch != null && data.odds.preMatch!.available)
              _buildBettingOddsSection(data.odds.preMatch!, isDark, context),

            // ===== GOALS PREDICTIONS =====
            _buildSectionTitle('Goals Predictions', Icons.sports_score, isDark, context),
            SizedBox(height: DynamicSize.small(context)),
            _buildGoalsPredictions(data.predictions, isDark, context),

            SizedBox(height: DynamicSize.large(context)),

            // ===== TOP SCORE PREDICTIONS =====
            _buildSectionTitle('Most Likely Scores', Icons.emoji_events, isDark, context),
            SizedBox(height: DynamicSize.small(context)),
            _buildTopScoresGrid(data.predictions.correctScores.top10, isDark, context),

            SizedBox(height: DynamicSize.large(context)),

            // ===== DOUBLE CHANCE =====
            _buildSectionTitle('Double Chance', Icons.casino, isDark, context),
            SizedBox(height: DynamicSize.small(context)),
            _buildDoubleChanceCards(data.predictions.doubleChance, isDark, context),

            SizedBox(height: DynamicSize.large(context)),
          ],
        ),
      );
    });
  }

  // ===== MATCH HEADER =====
  Widget _buildMatchHeader(FixtureInfo fixture, bool isDark, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      padding: EdgeInsets.all(DynamicSize.medium(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Color(0xFF1E293B), Color(0xFF0F172A)]
              : [Color(0xFFF8FAFC), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SColor.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // League Logo
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xFF334155) : Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  fixture.league.logo,
                  height: 32,
                  width: 32,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.sports_soccer,
                    size: 32,
                    color: SColor.primary,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fixture.league.name,
                      style: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      fixture.state.name,
                      style: STextTheme.subHeadLine().copyWith(
                        fontSize: 12,
                        color: fixture.state.isLive
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== SECTION TITLE =====
  Widget _buildSectionTitle(String title, IconData icon, bool isDark, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SColor.primary, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: STextTheme.headLine().copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===== MATCH OUTCOME CARDS =====
  Widget _buildMatchOutcomeCards(
      FullTimeResult result,
      String homeName,
      String awayName,
      bool isDark,
      BuildContext context,
      ) {
    final outcomes = [
      {'label': homeName, 'percentage': result.homeWin, 'icon': Icons.home},
      {'label': 'Draw', 'percentage': result.draw, 'icon': Icons.handshake},
      {'label': awayName, 'percentage': result.awayWin, 'icon': Icons.flight_land},
    ];

    // Find the highest probability
    final maxPercentage = [result.homeWin, result.draw, result.awayWin].reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: Row(
        children: outcomes.map((outcome) {
          final percentage = outcome['percentage'] as double;
          final isWinning = percentage == maxPercentage;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.all(DynamicSize.medium(context)),
              decoration: BoxDecoration(
                gradient: isWinning
                    ? LinearGradient(
                  colors: [SColor.primary, SColor.primary.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: !isWinning
                    ? (isDark ? Color(0xFF1E293B) : Colors.white)
                    : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isWinning
                      ? SColor.primary
                      : (isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
                  width: isWinning ? 2 : 1,
                ),
                boxShadow: isWinning
                    ? [
                  BoxShadow(
                    color: SColor.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    outcome['icon'] as IconData,
                    color: isWinning ? Colors.white : SColor.primary,
                    size: 24,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isWinning ? Colors.white : null,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    outcome['label'] as String,
                    style: STextTheme.subHeadLine().copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isWinning ? Colors.white : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===== BETTING ODDS SECTION =====
  Widget _buildBettingOddsSection(PreMatchOdds odds, bool isDark, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Betting Odds - ${odds.bookmakerName}', Icons.monetization_on, isDark, context),
        SizedBox(height: DynamicSize.small(context)),

        ...odds.markets.map((market) {
          final latestOdds = market.latestOdds;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DynamicSize.medium(context),
              vertical: 8,
            ),
            child: Container(
              padding: EdgeInsets.all(DynamicSize.medium(context)),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market.marketName,
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: latestOdds.entries.map((entry) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF334155) : Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                entry.key,
                                style: STextTheme.subHeadLine().copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                entry.value.value.toStringAsFixed(2),
                                style: STextTheme.headLine().copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: SColor.primary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                entry.value.probability,
                                style: STextTheme.subHeadLine().copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),

        SizedBox(height: DynamicSize.large(context)),
      ],
    );
  }

  // ===== GOALS PREDICTIONS =====
  Widget _buildGoalsPredictions(PredictionsData predictions, bool isDark, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: Column(
        children: [
          _buildGoalPredictionCard(
            'Both Teams to Score',
            Icons.sports_soccer,
            predictions.bothTeamsToScore.yes,
            predictions.bothTeamsToScore.no,
            'Yes',
            'No',
            isDark,
            context,
          ),
          SizedBox(height: 12),
          _buildGoalPredictionCard(
            'Over/Under 2.5 Goals',
            Icons.bar_chart,
            predictions.overUnder25.over,
            predictions.overUnder25.under,
            'Over 2.5',
            'Under 2.5',
            isDark,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPredictionCard(
      String title,
      IconData icon,
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
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: SColor.primary, size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: STextTheme.headLine().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: leftValue.toInt(),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [SColor.primary, SColor.primary.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${leftValue.toStringAsFixed(0)}%',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: rightValue.toInt(),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF475569) : Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${rightValue.toStringAsFixed(0)}%',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                rightLabel,
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== TOP SCORES GRID =====
  Widget _buildTopScoresGrid(List<TopScore> scores, bool isDark, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
        ),
        itemCount: scores.length > 6 ? 6 : scores.length,
        itemBuilder: (context, index) {
          final score = scores[index];
          final rank = index + 1;

          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: rank == 1
                  ? LinearGradient(
                colors: [
                  SColor.primary.withOpacity(0.2),
                  SColor.primary.withOpacity(0.1),
                ],
              )
                  : null,
              color: rank != 1
                  ? (isDark ? Color(0xFF1E293B) : Colors.white)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: rank == 1
                    ? SColor.primary
                    : (isDark ? Color(0xFF334155) : Color(0xFFE2E8F0)),
                width: rank == 1 ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? SColor.primary
                        : (isDark ? Color(0xFF334155) : Color(0xFFF1F5F9)),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#$rank',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: rank == 1 ? Colors.white : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        score.score,
                        style: STextTheme.headLine().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${score.probability.toStringAsFixed(1)}%',
                        style: STextTheme.subHeadLine().copyWith(
                          fontSize: 12,
                          color: SColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== DOUBLE CHANCE CARDS =====
  Widget _buildDoubleChanceCards(DoubleChance doubleChance, bool isDark, BuildContext context) {
    final options = [
      {'label': 'Home or Draw', 'value': doubleChance.homeOrDraw, 'icon': Icons.home},
      {'label': 'Away or Draw', 'value': doubleChance.awayOrDraw, 'icon': Icons.flight},
      {'label': 'Home or Away', 'value': doubleChance.homeOrAway, 'icon': Icons.compare_arrows},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
      child: Column(
        children: options.map((option) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(DynamicSize.medium(context)),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    option['icon'] as IconData,
                    color: SColor.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option['label'] as String,
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [SColor.primary, SColor.primary.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(option['value'] as double).toStringAsFixed(1)}%',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}