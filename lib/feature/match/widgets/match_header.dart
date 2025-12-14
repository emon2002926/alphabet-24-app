import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/match/controllers/summary_controller.dart';

class MatchHeader extends StatefulWidget {
  final String matchId;
  const MatchHeader({super.key, required this.matchId});

  @override
  State<MatchHeader> createState() => _MatchHeaderState();
}

class _MatchHeaderState extends State<MatchHeader> {
  final SummaryController summaryController = Get.put(SummaryController());

  @override
  void initState() {
    super.initState();
    summaryController.fetchSummary(widget.matchId);
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = DynamicSize.screenHeight(context) * 0.35;

    return Obx(() {
      if (summaryController.isLoading.value) {
        return Container(
          height: appBarHeight,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      }

      final data = summaryController.summaryData.value;

      if (data == null) {
        return Container(
          height: appBarHeight,
          alignment: Alignment.center,
          child: const Text(
            "No summary available",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final league = data.summary.league;
      final home = data.summary.homeTeam;
      final away = data.summary.awayTeam;
      final score = data.summary.score.current;

      return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Stack(
          children: [
            Container(
              height: appBarHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(league.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              height: appBarHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    Row(
                      children: [
                        Image.asset(IconPath.football, width: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          data.summary.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const Icon(Icons.favorite, color: Colors.white),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: appBarHeight * 0.22,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.network(home.logo, width: 70, height: 70),
                      const SizedBox(height: 6),
                      Text(home.name, style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        score.display ?? "${score.home}-${score.away}",
                        style: const TextStyle(fontSize: 42, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.summary.status.shortName,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Image.network(away.logo, width: 70, height: 70),
                      const SizedBox(height: 6),
                      Text(away.name, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

