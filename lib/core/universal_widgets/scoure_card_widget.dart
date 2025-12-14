import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../../feature/home/models/live_match_response_model.dart';
import '../theme/SColor.dart';
import '../theme/text_theme.dart';

class ScoureCardWidget extends StatelessWidget {
  final int? index;
  final LiveMatch? match;
  final bool shrink;

  ScoureCardWidget({
    this.index,
    this.match,
    this.shrink = false,
    super.key,
  }) : assert(
  (index != null && match == null) || (index == null && match != null),
  'Either provide index OR match, not both',
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballLiveMatchController>();

    // Get match from controller if index is provided, otherwise use the provided match
    final LiveMatch matchData = match ?? controller.liveMatches[index!];

    // ===== SAFE PERIOD CHECK =====
    final hasPeriod = matchData.periods.isNotEmpty;
    final periodMinutes = hasPeriod ? matchData.periods[0].minutes : 0;
    final periodDescription = hasPeriod ? matchData.periods[0].description : "-";

    // ===== SAFE PREDICTION CHECK =====
    final full = matchData.predictions.fulltimeResult;
    final homeProb = full.homeWin.toDouble();
    final drawProb = full.draw.toDouble();
    final awayProb = full.awayWin.toDouble();

    final fullTotal = (homeProb + drawProb + awayProb).clamp(1, 300);
    final homeFlex = ((homeProb / fullTotal) * 100).round().clamp(1, 100);
    final drawFlex = ((drawProb / fullTotal) * 100).round().clamp(1, 100);
    final awayFlex = ((awayProb / fullTotal) * 100).round().clamp(1, 100);

    // ===== SAFE TOP SCORE CHECK =====
    final hasTopScore = matchData.predictions.correctScores.top5.isNotEmpty;
    final topScore = hasTopScore
        ? matchData.predictions.correctScores.top5[0].score
        : "0-0";
    final topProbability = hasTopScore
        ? matchData.predictions.correctScores.top5[0].probability.toDouble()
        : 0;

    final goalHomeFlex = topProbability.round().clamp(1, 100);
    final goalAwayFlex = (100 - goalHomeFlex).clamp(1, 100);

    // ===== DYNAMIC SIZING BASED ON SHRINK =====
    final cardPadding = shrink ? 8.0 : 12.0;
    final verticalSpacing = shrink ? 4.0 : 8.0;
    final sectionSpacing = shrink ? 6.0 : 12.0;
    final logoSize = shrink ? 24.0 : 32.0;
    final smallLogoSize = shrink ? 14.0 : 16.0;
    final leagueLogoSize = shrink ? 16.0 : 20.0;
    final scoreFontSize = shrink ? 16.0 : 20.0;
    final headingFontSize = shrink ? 12.0 : 14.0;
    final textFontSize = shrink ? 10.0 : 12.0;
    final barHeight = shrink ? 4.0 : 6.0;

    return GestureDetector(
      onTap: () => Get.to(
        MatchDetailsScreen(),
        arguments: {'matchId': matchData.id},
      ),
      child: Card(
        color: Get.theme.brightness == Brightness.dark
            ? const Color(0xFF3E3E3E)
            : const Color(0xFFFFFFFF),
        elevation: 2,
        margin: EdgeInsets.symmetric(
          horizontal: shrink ? 4 : 8,
          vertical: shrink ? 4 : 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== LEAGUE HEADER WITH FAVORITE BUTTON =====
              Row(
                children: [
                  Image.network(
                    matchData.league.logo,
                    height: leagueLogoSize,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.sports_soccer, size: leagueLogoSize),
                  ),
                  Spacer(),
                  Text(
                    hasPeriod ? "${periodMinutes}'" : "-",
                    style: STextTheme.headLine().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: headingFontSize,
                    ),
                  ),
                  SizedBox(width: 8),
                  // ===== FAVORITE BUTTON =====
                  Obx(() {
                    // Get favorite status from controller's list
                    final isFavorite = index != null
                        ? controller.liveMatches[index!].isFavoriteMatch
                        : matchData.isFavoriteMatch;

                    return GestureDetector(
                      onTap: () {
                        // Call controller toggle method
                        controller.toggleFavorite(matchData.id);
                      },
                      child: Container(
                        padding: EdgeInsets.all(shrink ? 4 : 6),
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? Colors.red.withOpacity(0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: shrink ? 18 : 22,
                          color: isFavorite
                              ? Colors.red
                              : (Get.theme.brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              SizedBox(height: verticalSpacing),

              // ===== SCORE ROW =====
              Padding(
                padding: EdgeInsets.symmetric(vertical: shrink ? 4 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home Team
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            matchData.homeTeam.logo,
                            height: logoSize,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.shield, size: logoSize),
                          ),
                          SizedBox(height: shrink ? 2 : 4),
                          Text(
                            matchData.homeTeam.name,
                            style: STextTheme.scoureText().copyWith(
                              fontSize: shrink ? 10 : null,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Score
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: shrink ? 8 : 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            matchData.score.display,
                            style: STextTheme.headLine().copyWith(
                              fontSize: scoreFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            periodDescription,
                            style: STextTheme.subHeadLine().copyWith(
                              fontSize: shrink ? 8 : 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            matchData.awayTeam.logo,
                            height: logoSize,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.shield, size: logoSize),
                          ),
                          SizedBox(height: shrink ? 2 : 4),
                          Text(
                            matchData.awayTeam.name,
                            style: STextTheme.scoureText().copyWith(
                              fontSize: shrink ? 10 : null,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: verticalSpacing),

              // ===== WINNING POSSIBILITY SECTION =====
              Center(
                child: Text(
                  'Winning Possibility',
                  style: STextTheme.headLine().copyWith(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: shrink ? 4 : 6),

              // ===== FULLTIME RESULT TEXT =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        matchData.homeTeam.logo,
                        height: smallLogoSize,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.shield, size: smallLogoSize),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${homeProb.toStringAsFixed(0)}%",
                        style: STextTheme.subHeadLine().copyWith(
                          fontSize: textFontSize,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Draw ${drawProb.toStringAsFixed(0)}%",
                    style: STextTheme.subHeadLine().copyWith(
                      fontSize: textFontSize,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${awayProb.toStringAsFixed(0)}%",
                        style: STextTheme.subHeadLine().copyWith(
                          fontSize: textFontSize,
                        ),
                      ),
                      SizedBox(width: 4),
                      Image.network(
                        matchData.awayTeam.logo,
                        height: smallLogoSize,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.shield, size: smallLogoSize),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: shrink ? 4 : 6),

              // ===== FULLTIME RESULT BAR =====
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: homeFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          color: SColor.progressIndicator1,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: drawFlex,
                      child: Container(
                        color: SColor.progressIndicator2,
                      ),
                    ),
                    Expanded(
                      flex: awayFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          color: SColor.progressIndicator3,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sectionSpacing),

              // ===== GOAL PREDICTION SECTION =====
              Center(
                child: Text(
                  'Goal Prediction (Top Pick)',
                  style: STextTheme.headLine().copyWith(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: shrink ? 4 : 6),

              // ===== GOAL PREDICTION TEXT =====
              Row(
                children: [
                  Image.network(
                    matchData.homeTeam.logo,
                    height: smallLogoSize,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.shield, size: smallLogoSize),
                  ),
                  Spacer(),
                  Text(
                    "$topScore ",
                    style: STextTheme.subHeadLine().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: textFontSize,
                    ),
                  ),
                  Spacer(),
                  Image.network(
                    matchData.awayTeam.logo,
                    height: smallLogoSize,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.shield, size: smallLogoSize),
                  ),
                ],
              ),

              SizedBox(height: shrink ? 4 : 6),

              // ===== GOAL PREDICTION BAR =====
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: goalHomeFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          color: SColor.progressIndicator1,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: goalAwayFlex,
                      child: Container(
                        decoration: BoxDecoration(
                          color: SColor.progressIndicator3,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
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
  }
}