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
          child: const CircularProgressIndicator(color: Colors.white),
        );
      }

      final data = summaryController.summaryData.value;

      if (data == null) {
        return Container(
          height: appBarHeight,
          alignment: Alignment.center,
          child: const Text(
            "No summary available",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

      final league = data.summary.league;
      final home = data.summary.homeTeam;
      final away = data.summary.awayTeam;
      final score = data.summary.score.current;

      return Stack(
        children: [
          // Background Image
          Container(
            height: appBarHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(league.logo),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            height: appBarHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Top Bar with Back Button and Match Name
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),

                  // League name with flexible width
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          IconPath.football,
                          width: 18,
                          height: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            data.summary.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Add favorite functionality
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Match Score and Teams (Fixed overflow issue)
          Positioned(
            bottom: appBarHeight * 0.18,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home Team (with Expanded to prevent overflow)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          home.logo,
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.sports_soccer, size: 35),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          home.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Score and Status (fixed width)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          score.display ?? "${score.home} - ${score.away}",
                          style: const TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.summary.status.shortName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Away Team (with Expanded to prevent overflow)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          away.logo,
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.sports_soccer, size: 35),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          away.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}