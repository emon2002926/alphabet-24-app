import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/universal_widgets/appbar.dart';
import '../controllers/league_detail_controller.dart';
import '../models/league_detail_response.dart';

class LigueMatchListScreen extends StatelessWidget {
  LigueMatchListScreen({super.key});

  late final LeagueDetailController controller;

  @override
  Widget build(BuildContext context) {
    final int leagueId = Get.arguments['leagueId'] as int;
    controller = Get.put(LeagueDetailController(leagueId: leagueId));

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'Ligue Matches'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.liveMatches.isEmpty && controller.todayFixtures.isEmpty) {
          return const Center(child: Text('No matches today'));
        }

        return ListView(
          padding: EdgeInsets.all(DynamicSize.medium(context)),
          children: [
            if (controller.liveMatches.isNotEmpty) ...[
              const Text('Live Matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.liveMatches
                  .map((match) => _buildMatchRow(match, context, isLive: true)),
              SizedBox(height: DynamicSize.medium(context)),
            ],
            if (controller.todayFixtures.isNotEmpty) ...[
              const Text('Today\'s Fixtures',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.todayFixtures
                  .map((match) => _buildMatchRow(match, context, isLive: false)),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildMatchRow(LeagueMatch match, BuildContext context, {required bool isLive}) {
    final bool hasScore = match.homeTeam.score != null && match.awayTeam.score != null;

    return GestureDetector(
      onTap: () {
        Get.to(MatchDetailsScreen(), arguments: {
          'matchId': match.id,
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: DynamicSize.medium(context)),
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Favorite Icon
            GestureDetector(
              onTap: () {
                // Toggle favorite
              },
              child: Icon(Icons.star_border, color: SColor.primary, size: 24),
            ),

            SizedBox(width: DynamicSize.medium(context)),

            // Teams Section
            Expanded(
              child: Column(
                children: [
                  // Home Team Row
                  Row(
                    children: [
                      // Home Team Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          match.homeTeam.logo,
                          width: 24,
                          height: 24,
                          errorBuilder: (_, __, ___) => Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.sports_soccer, size: 14, color: Colors.grey[600]),
                          ),
                        ),
                      ),

                      SizedBox(width: 8),

                      // Home Team Name
                      Expanded(
                        child: Text(
                          match.homeTeam.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Home Score (if available)
                      if (hasScore)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${match.homeTeam.score}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Away Team Row
                  Row(
                    children: [
                      // Away Team Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          match.awayTeam.logo,
                          width: 24,
                          height: 24,
                          errorBuilder: (_, __, ___) => Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.sports_soccer, size: 14, color: Colors.grey[600]),
                          ),
                        ),
                      ),

                      SizedBox(width: 8),

                      // Away Team Name
                      Expanded(
                        child: Text(
                          match.awayTeam.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Away Score (if available)
                      if (hasScore)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${match.awayTeam.score}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: DynamicSize.medium(context)),

            // Right Side: Date, Time, Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Date
                Text(
                  _formatMatchDate(match.startingAt),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 4),

                // Live Badge or Time
                if (isLive && hasScore)
                // Live Badge with minute
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF3B3B), Color(0xFFFF6B6B)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF3B3B).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pulsing dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'LIVE',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                // Start Time for upcoming matches
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: SColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: SColor.primary, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: SColor.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatMatchTime(match.startingAt),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: SColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 6),

                // Status/Minute
                if (isLive)
                // Show minute for live matches
                  Text(
                    _extractMinute(match.state),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                else
                // Show status for upcoming matches
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getStatusColor(match.state).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      match.state,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(match.state),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMatchTime(String startingAt) {
    try {
      final dateTime = DateTime.parse(startingAt);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return startingAt;
    }
  }

  String _formatMatchDate(String startingAt) {
    try {
      final dateTime = DateTime.parse(startingAt);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final matchDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (matchDate == today) {
        return 'Today';
      } else if (matchDate == today.add(Duration(days: 1))) {
        return 'Tomorrow';
      } else if (matchDate == today.subtract(Duration(days: 1))) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }

  String _extractMinute(String state) {
    // Extract minute from state like "1H 23'" or "2H 67'"
    final minuteMatch = RegExp(r"(\d+)'").firstMatch(state);
    if (minuteMatch != null) {
      return "${minuteMatch.group(1)}'";
    }
    return state;
  }

  Color _getStatusColor(String status) {
    if (status.contains('1H') || status.contains('2H') || status.toLowerCase().contains('live')) {
      return Colors.red;
    } else if (status.toLowerCase().contains('ft') || status.toLowerCase().contains('finished')) {
      return Colors.green;
    } else if (status.toLowerCase().contains('ns') || status.toLowerCase().contains('not started')) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}