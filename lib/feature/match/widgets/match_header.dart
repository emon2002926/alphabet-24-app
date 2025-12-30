import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Reduced height for compact design
    final appBarHeight = 200.0;

    return Obx(() {
      if (summaryController.isLoading.value) {
        return Container(
          height: appBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1929), Color(0xFF0D2847)],
            ),
          ),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Colors.white),
        );
      }

      final data = summaryController.summaryData.value;

      if (data == null) {
        return Container(
          height: appBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1929), Color(0xFF0D2847)],
            ),
          ),
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

      return Container(
        height: appBarHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1929), Color(0xFF0D2847)],
          ),
        ),
        child: Stack(
          children: [
            // Subtle background overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.network(
                  league.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Top Bar - More compact
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button - smaller
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        // League info - centered
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: Image.network(
                                  league.logo,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.sports_soccer,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  data.summary.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Favorite Button - smaller
                        GestureDetector(
                          onTap: () {
                            // Add favorite functionality
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Match Display - Compact and Bold
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Home Team
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Team Logo - larger and cleaner
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  home.logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.sports_soccer,
                                      size: 40,
                                      color: Colors.white.withOpacity(0.5),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Team Name - bold
                              Text(
                                home.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Score and Status
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Score - bigger and bolder
                              Text(
                                score.display ?? "${score.home} - ${score.away}",
                                style: GoogleFonts.poppins(
                                  fontSize: 44,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Status - smaller badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: data.summary.status.isLive
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: data.summary.status.isLive
                                        ? Colors.red
                                        : Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  data.summary.status.shortName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
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
                              // Team Logo - larger and cleaner
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  away.logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.sports_soccer,
                                      size: 40,
                                      color: Colors.white.withOpacity(0.5),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Team Name - bold
                              Text(
                                away.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  height: 1.2,
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}