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
                                style: GoogleFonts.roboto
                                  (
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
                                style: GoogleFonts.roboto(
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
          padding: EdgeInsets.symmetric(horizontal: 12),

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
              SizedBox(width: 8),

              // League Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    Text(
                      leagueGroup.leagueName,
                      style: STextTheme.scoureTextSmall().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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

    // ===== PREDICTION VALUES =====
    final full = match.predictions.fulltimeResult;
    final homeProb = full.homeWin.toDouble();
    final drawProb = full.draw.toDouble();
    final awayProb = full.awayWin.toDouble();

    final overProb = match.predictions.overUnder25.over;
    final underProb = match.predictions.overUnder25.under;

    return GestureDetector(
      onTap: () => Get.to(
        MatchDetailsScreen(),
        arguments: {'matchId': match.id},
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), // Increased from 10 to 14
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== TOP ROW: MINUTE/TIME & FAVORITE =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live minute or start time
                  if (match.status.isLive && hasPeriod)
                    Text(
                      "$periodMinutes'",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    )
                  else
                    Text(
                      DateFormat('HH:mm').format(match.startingAt),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SColor.primary,
                      ),
                    ),
                  // Favorite button
                  GestureDetector(
                    onTap: () => footballController.toggleFavoriteInGroup(
                      leagueIndex,
                      matchIndex,
                    ),
                    child: Icon(
                      match.isFavoriteMatch
                          ? Icons.star
                          : Icons.star_border,
                      color: match.isFavoriteMatch
                          ? Colors.amber
                          : Colors.grey[400],
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8), // Increased from 6 to 8

              // ===== HOME TEAM ROW =====
              _buildTeamRow(
                logo: match.homeTeam.logo,
                name: match.homeTeam.name,
                score: match.homeTeam.score,
                isLive: match.status.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 6), // Increased from 4 to 6

              // ===== AWAY TEAM ROW =====
              _buildTeamRow(
                logo: match.awayTeam.logo,
                name: match.awayTeam.name,
                score: match.awayTeam.score,
                isLive: match.status.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 10), // Increased from 8 to 10

              // ===== PREDICTION BOXES (1, X, 2) =====
              SizedBox(
                height: 30, // Increased from 28 to 30
                child: Row(
                  children: [
                    // Home Win (1)
                    Expanded(
                      flex: homeProb.round().clamp(1, 100),
                      child: _buildPredictionBox(
                        label: '1',
                        percentage: homeProb,
                        color: const Color(0xFF0096C7),
                        textColor: const Color(0xFF01002B),
                        percentageColor: const Color(0xFF01002B),
                      ),
                    ),
                    const SizedBox(width: 3),
                    // Draw (X)
                    Expanded(
                      flex: drawProb.round().clamp(1, 100),
                      child: _buildPredictionBox(
                        label: 'X',
                        percentage: drawProb,
                        color: const Color(0xFFD0D4DC),
                        textColor: Colors.black87,
                        percentageColor: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 3),
                    // Away Win (2)
                    Expanded(
                      flex: awayProb.round().clamp(1, 100),
                      child: _buildPredictionBox(
                        label: '2',
                        percentage: awayProb,
                        color: const Color(0xFF01002A),
                        textColor: Colors.black,
                        percentageColor: const Color(0xFF0096C6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8), // Increased from 6 to 8

              // ===== OVER/UNDER 2.5 BOXES =====
              SizedBox(
                height: 30, // Increased from 28 to 30
                child: Row(
                  children: [
                    // Over 2.5
                    Expanded(
                      child: _buildOverUnderBox(
                        label: 'Over 2.5',
                        percentage: overProb,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Under 2.5
                    Expanded(
                      child: _buildOverUnderBox(
                        label: 'Under 2.5',
                        percentage: underProb,
                        isDark: isDark,
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

  Widget _buildTeamRow({
    required String logo,
    required String name,
    required int score,
    required bool isLive,
    required bool isDark,
  }) {
    return Row(
      children: [
        // Team logo
        Image.network(
          logo,
          height: 22, // Increased from 20 to 22
          width: 22, // Increased from 20 to 22
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sports_soccer,
            size: 22, // Increased from 20 to 22
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        // Team name
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Score
        Text(
          isLive ? score.toString() : '-',
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionBox({
    required String label,
    required double percentage,
    required Color color,
    required Color textColor,
    Color? percentageColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: percentageColor ?? textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverUnderBox({
    required String label,
    required double percentage,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), // Increased vertical from 4 to 5
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF4A4A4A) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF015440),
            ),
          ),
        ],
      ),
    );
  }
}