import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';

import '../../home/models/live_match_response_model.dart';
import '../../match/views/match_details_screen.dart';

class PredictedFootballTab extends StatefulWidget {
  const PredictedFootballTab({super.key});

  @override
  State<PredictedFootballTab> createState() => _PredictedFootballTabState();
}

class _PredictedFootballTabState extends State<PredictedFootballTab> {
  final FootballLiveMatchController footballLiveMatchController =
  Get.put(FootballLiveMatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: Obx(() {
        // Loading state
        if (footballLiveMatchController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Get grouped matches
        final groupedMatches = footballLiveMatchController.groupedMatches;
        final liveCount = footballLiveMatchController.liveMatches.length;
        final upcomingCount = footballLiveMatchController.upcomingMatches.length;
        final totalMatches = liveCount + upcomingCount;

        // Empty state
        if (groupedMatches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_soccer,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "No matches available",
                  style: STextTheme.headLine().copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Display grouped matches
        return RefreshIndicator(
          onRefresh: () => footballLiveMatchController.fetchMatches(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Match Count Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: DynamicSize.medium(context),
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Live matches badge (if any)
                      if (liveCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$liveCount LIVE',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Upcoming matches badge (if any)
                      if (upcomingCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: SColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: SColor.primary,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: SColor.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$upcomingCount UPCOMING',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: SColor.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // League count
                      Text(
                        '• ${groupedMatches.length} ${groupedMatches.length == 1 ? 'League' : 'Leagues'}',
                        style: STextTheme.subHeadLine().copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // League Groups
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: groupedMatches.length,
                  itemBuilder: (context, leagueIndex) {
                    final leagueGroup = groupedMatches[leagueIndex];
                    return _LeagueGroupWidget(
                      leagueGroup: leagueGroup,
                      leagueIndex: leagueIndex,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// League Group Widget
class _LeagueGroupWidget extends StatelessWidget {
  final LeagueGroup leagueGroup;
  final int leagueIndex;

  const _LeagueGroupWidget({
    required this.leagueGroup,
    required this.leagueIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // League Header
        Container(
          margin: EdgeInsets.only(
            top: DynamicSize.medium(context),
            left: DynamicSize.small(context),
            right: DynamicSize.small(context),
          ),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // League Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 32,
                  height: 32,
                  color: Colors.white,
                  padding: EdgeInsets.all(4),
                  child: Image.network(
                    leagueGroup.leagueLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.sports_soccer,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),

              // League Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leagueGroup.countryName,
                      style: STextTheme.subHeadLine().copyWith(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      leagueGroup.leagueName,
                      style: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Match Count Badges
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Live count (if any)
                  if (leagueGroup.liveCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${leagueGroup.liveCount} LIVE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),

                  // Total count
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: SColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${leagueGroup.totalCount}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Matches for this league
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: leagueGroup.matches.length,
            itemBuilder: (context, matchIndex) {
              return _GroupedMatchCard(
                match: leagueGroup.matches[matchIndex],
                leagueIndex: leagueIndex,
                matchIndex: matchIndex,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Grouped Match Card Widget
class _GroupedMatchCard extends StatelessWidget {
  final LiveMatch match;
  final int leagueIndex;
  final int matchIndex;

  const _GroupedMatchCard({
    required this.match,
    required this.leagueIndex,
    required this.matchIndex,
  });

  @override
  Widget build(BuildContext context) {
    final footballController = Get.find<FootballLiveMatchController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ===== SAFE CHECKS =====
    final hasPeriod = match.periods.isNotEmpty;
    final periodMinutes = hasPeriod ? match.periods[0].minutes : 0;
    final periodDescription = hasPeriod ? match.periods[0].description : "-";

    final full = match.predictions.fulltimeResult;
    final homeProb = full.homeWin.toDouble();
    final drawProb = full.draw.toDouble();
    final awayProb = full.awayWin.toDouble();

    final fullTotal = (homeProb + drawProb + awayProb).clamp(1, 300);
    final homeFlex = ((homeProb / fullTotal) * 100).round().clamp(1, 100);
    final drawFlex = ((drawProb / fullTotal) * 100).round().clamp(1, 100);
    final awayFlex = ((awayProb / fullTotal) * 100).round().clamp(1, 100);

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
        color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF1F1F1),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time/Status and Favorite Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time or Minute
                  if (match.status.isLive && hasPeriod)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "$periodMinutes'",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    )
                  else
                    Text(
                      DateFormat('HH:mm').format(match.startingAt),
                      style: STextTheme.subHeadLine().copyWith(fontSize: 12),
                    ),

                  // Favorite Button
                  GestureDetector(
                    onTap: () => footballController.toggleFavoriteInGroup(
                      leagueIndex,
                      matchIndex,
                    ),
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

              const SizedBox(height: 8),

              // Teams and Score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.network(match.homeTeam.logo, height: 28),
                        const SizedBox(height: 4),
                        Text(
                          match.homeTeam.name,
                          style: STextTheme.headLine().copyWith(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          match.score.display,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          match.status.isLive ? periodDescription : match.status.stateShort,
                          style: STextTheme.subHeadLine().copyWith(
                            fontSize: 10,
                            color: match.status.isLive ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.network(match.awayTeam.logo, height: 28),
                        const SizedBox(height: 4),
                        Text(
                          match.awayTeam.name,
                          style: STextTheme.headLine().copyWith(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Winning Possibility
              Text(
                'Winning Possibility',
                style: STextTheme.headLine().copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(match.homeTeam.logo, height: 12),
                      const SizedBox(width: 3),
                      Text("${homeProb.toStringAsFixed(0)}%",
                          style: STextTheme.subHeadLine().copyWith(fontSize: 10)),
                    ],
                  ),
                  Text("Draw ${drawProb.toStringAsFixed(0)}%",
                      style: STextTheme.subHeadLine().copyWith(fontSize: 10)),
                  Row(
                    children: [
                      Text("${awayProb.toStringAsFixed(0)}%",
                          style: STextTheme.subHeadLine().copyWith(fontSize: 10)),
                      const SizedBox(width: 3),
                      Image.network(match.awayTeam.logo, height: 12),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Progress Bar
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
                    Expanded(flex: drawFlex, child: Container(color: SColor.progressIndicator2)),
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

              const SizedBox(height: 8),

              // Goal Prediction
              Text(
                'Goal Prediction (Top Pick)',
                style: STextTheme.headLine().copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  Image.network(match.homeTeam.logo, height: 12),
                  const Spacer(),
                  Text(
                    topScore,
                    style: STextTheme.headLine().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Image.network(match.awayTeam.logo, height: 12),
                ],
              ),

              const SizedBox(height: 4),

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
  }
}