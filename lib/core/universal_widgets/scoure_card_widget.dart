import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../theme/SColor.dart';
import '../theme/text_theme.dart';

class ScoureCardWidget extends StatelessWidget {
  final int index;

  const ScoureCardWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final liveMatchController = Get.find<FootballLiveMatchController>();

    return Obx(() {
      final match = liveMatchController.liveMatches[index];

      // ===== SAFE PERIOD CHECK =====
      final hasPeriod = match.periods.isNotEmpty;
      final periodMinutes = hasPeriod ? match.periods[0].minutes : 0;
      final periodDescription = hasPeriod ? match.periods[0].description : "-";

      // ===== SAFE PREDICTION CHECK =====
      final full = match.predictions.fulltimeResult;
      final homeProb = full.homeWin.toDouble();
      final drawProb = full.draw.toDouble();
      final awayProb = full.awayWin.toDouble();

      final fullTotal = (homeProb + drawProb + awayProb).clamp(1, 300);
      final homeFlex = ((homeProb / fullTotal) * 100).round().clamp(1, 100);
      final drawFlex = ((drawProb / fullTotal) * 100).round().clamp(1, 100);
      final awayFlex = ((awayProb / fullTotal) * 100).round().clamp(1, 100);

      // ===== SAFE TOP SCORE CHECK =====
      final hasTopScore = match.predictions.correctScores.top5.isNotEmpty;
      final topScore = hasTopScore ? match.predictions.correctScores.top5[0].score : "0-0";
      final topProbability = hasTopScore ? match.predictions.correctScores.top5[0].probability.toDouble() : 0;

      final goalHomeFlex = topProbability.round().clamp(1, 100);
      final goalAwayFlex = (100 - goalHomeFlex).clamp(1, 100);

      return GestureDetector(
        onTap: () => Get.to(
          MatchDetailsScreen(),
          arguments: {'matchId': match.id},
        ),
        child: Card(
          color: Get.theme.brightness == Brightness.dark
              ? const Color(0xFF3E3E3E)
              : const Color(0xFFFFFFFF),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== LEAGUE HEADER WITH FAVORITE BUTTON =====
                Row(
                  children: [
                    Image.network(match.league.logo, height: 20),
                    const Spacer(),
                    Text(
                      hasPeriod ? "${periodMinutes}'" : "-",
                      style: STextTheme.headLine().copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => liveMatchController.toggleFavorite(index),
                      child: Icon(
                        match.isFavoriteMatch
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: match.isFavoriteMatch ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ===== SCORE ROW =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(match.homeTeam.logo, height: 28),
                          const SizedBox(height: 2),
                          Text(
                            match.homeTeam.name,
                            style: STextTheme.scoureText().copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Text(
                            match.score.display,
                            style: STextTheme.headLine().copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            periodDescription,
                            style: STextTheme.subHeadLine().copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(match.awayTeam.logo, height: 28),
                          const SizedBox(height: 2),
                          Text(
                            match.awayTeam.name,
                            style: STextTheme.scoureText().copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ===== WINNING POSSIBILITY =====
                Center(
                  child: Text(
                    'Winning Possibility',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // ===== FULLTIME RESULT TEXT =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(match.homeTeam.logo, height: 14),
                        const SizedBox(width: 3),
                        Text("${homeProb.toStringAsFixed(0)}%",
                            style: STextTheme.subHeadLine().copyWith(fontSize: 11)),
                      ],
                    ),
                    Text("Draw ${drawProb.toStringAsFixed(0)}%",
                        style: STextTheme.subHeadLine().copyWith(fontSize: 11)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${awayProb.toStringAsFixed(0)}%",
                            style: STextTheme.subHeadLine().copyWith(fontSize: 11)),
                        const SizedBox(width: 3),
                        Image.network(match.awayTeam.logo, height: 14),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // ===== FULLTIME RESULT BAR =====
                Container(
                  height: 4,
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
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: drawFlex,
                        child: Container(color: SColor.progressIndicator2),
                      ),
                      Expanded(
                        flex: awayFlex,
                        child: Container(
                          decoration: BoxDecoration(
                            color: SColor.progressIndicator3,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // ===== GOAL PREDICTION =====
                Center(
                  child: Text(
                    'Goal Prediction (Top Pick)',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // ===== GOAL PREDICTION TEXT =====
                Row(
                  children: [
                    Image.network(match.homeTeam.logo, height: 14),
                    const Spacer(),
                    Text(
                      "$topScore",
                      style: STextTheme.subHeadLine().copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Image.network(match.awayTeam.logo, height: 14),
                  ],
                ),

                const SizedBox(height: 3),

                // ===== GOAL PREDICTION BAR =====
                Container(
                  height: 4,
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
                            borderRadius: const BorderRadius.only(
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
                            borderRadius: const BorderRadius.only(
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
    });
  }
}