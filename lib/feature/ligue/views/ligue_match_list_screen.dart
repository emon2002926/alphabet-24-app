import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/universal_widgets/appbar.dart';
import '../../home/models/leage_list_model.dart';
import '../controllers/league_detail_controller.dart';
import '../models/league_detail_response.dart';

class LigueMatchListScreen extends StatelessWidget {
  const LigueMatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int leagueId = Get.arguments['leagueId'] as int;
    final String? leagueName = Get.arguments?['leagueName'] as String?;
    final List<Match>? matchList = Get.arguments?['PrimaryLeagueList'] as List<Match>?;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Always use controller for favorite functionality
    final controller = Get.put(LeagueDetailController(leagueId: leagueId));

    if (matchList != null && matchList.isNotEmpty) {
      return _buildWithPassedData(context, matchList, leagueName, isDark, controller);
    }

    return _buildWithController(context, controller, leagueName, isDark);
  }

  Widget _buildWithPassedData(
      BuildContext context,
      List<Match> matchList,
      String? leagueName,
      bool isDark,
      LeagueDetailController controller,
      ) {
    final liveMatches = matchList.where((m) => m.status.isLive).toList();
    final finishedMatches = matchList.where((m) => m.status.isFinished).toList();
    final upcomingMatches = matchList.where((m) => m.status.isUpcoming).toList();
    final todayFixtures = [...finishedMatches, ...upcomingMatches];

    // Initialize favorites for passed matches
    for (var match in matchList) {
      if (!controller.favoriteFixtures.containsKey(match.id)) {
        controller.favoriteFixtures[match.id] = false;
      }
    }

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: leagueName ?? 'League Matches'),
      body: ListView(
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        children: [
          if (liveMatches.isNotEmpty) ...[
            Text(
              'Live Matches',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: DynamicSize.small(context)),
            ...liveMatches.map((match) => _buildMatchRow(match, context, controller, isLive: true)),
            SizedBox(height: DynamicSize.medium(context)),
          ],
          if (todayFixtures.isNotEmpty) ...[
            Text(
              "Today's Fixtures",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: DynamicSize.small(context)),
            ...todayFixtures.map((match) => _buildMatchRow(match, context, controller, isLive: false)),
          ],
          if (liveMatches.isEmpty && todayFixtures.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'No matches available',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWithController(
      BuildContext context,
      LeagueDetailController controller,
      String? leagueName,
      bool isDark,
      ) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: leagueName ?? 'League Matches'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.liveMatches.isEmpty && controller.todayFixtures.isEmpty) {
          return Center(
            child: Text(
              'No matches today',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(DynamicSize.medium(context)),
          children: [
            if (controller.liveMatches.isNotEmpty) ...[
              Text(
                'Live Matches',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.liveMatches
                  .map((match) => _buildLeagueMatchRow(match, context, controller, isLive: true)),
              SizedBox(height: DynamicSize.medium(context)),
            ],
            if (controller.todayFixtures.isNotEmpty) ...[
              Text(
                "Today's Fixtures",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.todayFixtures
                  .map((match) => _buildLeagueMatchRow(match, context, controller, isLive: false)),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildMatchRow(
      Match match,
      BuildContext context,
      LeagueDetailController controller,
      {required bool isLive}
      ) {
    final bool hasScore = match.homeTeam.score != null && match.awayTeam.score != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(() => MatchDetailsScreen(), arguments: {'matchId': match.id});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: DynamicSize.medium(context)),
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Favorite Icon with Obx
            Obx(() {
              final isFav = controller.isFavorite(match.id);
              return GestureDetector(
                onTap: () => controller.toggleFavorite(match.id),
                child: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.amber : Colors.grey,
                  size: 24,
                ),
              );
            }),
            SizedBox(width: DynamicSize.medium(context)),
            Expanded(
              child: Column(
                children: [
                  _teamRow(match.homeTeam.name, match.homeTeam.logo, match.homeTeam.score, hasScore, isDark),
                  SizedBox(height: 10),
                  _teamRow(match.awayTeam.name, match.awayTeam.logo, match.awayTeam.score, hasScore, isDark),
                ],
              ),
            ),
            SizedBox(width: DynamicSize.medium(context)),
            _matchInfo(match.startingAt, isLive, match.status.stateName, _getStatusColor(match.status), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueMatchRow(
      LeagueMatch match,
      BuildContext context,
      LeagueDetailController controller,
      {required bool isLive}
      ) {
    final bool hasScore = match.homeTeam.score != null && match.awayTeam.score != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(() => MatchDetailsScreen(), arguments: {'matchId': match.id});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: DynamicSize.medium(context)),
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Favorite Icon with Obx to react to changes
            Obx(() {
              final isFav = controller.isFavorite(match.id);
              return GestureDetector(
                onTap: () => controller.toggleFavorite(match.id),
                child: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.amber : Colors.grey,
                  size: 24,
                ),
              );
            }),
            SizedBox(width: DynamicSize.medium(context)),
            Expanded(
              child: Column(
                children: [
                  _teamRow(match.homeTeam.name, match.homeTeam.logo, match.homeTeam.score, hasScore, isDark),
                  SizedBox(height: 10),
                  _teamRow(match.awayTeam.name, match.awayTeam.logo, match.awayTeam.score, hasScore, isDark),
                ],
              ),
            ),
            SizedBox(width: DynamicSize.medium(context)),
            _matchInfo(match.startingAt, isLive, match.state, _getStateColor(match.state), isDark),
          ],
        ),
      ),
    );
  }

  Widget _teamRow(String name, String logo, int? score, bool hasScore, bool isDark) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            logo,
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.sports_soccer, size: 14, color: Colors.grey[600]),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasScore)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${score ?? 0}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
      ],
    );
  }

  Widget _matchInfo(String startingAt, bool isLive, String stateShort, Color statusColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatMatchDate(startingAt),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        if (isLive)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFF3B3B), Color(0xFFFF6B6B)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                SizedBox(width: 6),
                Text('LIVE', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          )
        else
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
                Icon(Icons.access_time, size: 14, color: SColor.primary),
                SizedBox(width: 4),
                Text(_formatMatchTime(startingAt), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: SColor.primary)),
              ],
            ),
          ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            stateShort,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ),
      ],
    );
  }

  String _formatMatchTime(String startingAt) {
    try {
      return DateFormat('HH:mm').format(DateTime.parse(startingAt));
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

      if (matchDate == today) return 'Today';
      if (matchDate == today.add(Duration(days: 1))) return 'Tomorrow';
      if (matchDate == today.subtract(Duration(days: 1))) return 'Yesterday';
      return DateFormat('MMM dd').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  Color _getStatusColor(MatchStatus status) {
    if (status.isLive) return Colors.red;
    if (status.isFinished) return Colors.green;
    if (status.isUpcoming) return Colors.blue;
    return Colors.grey;
  }

  Color _getStateColor(String state) {
    if (state.contains('1H') || state.contains('2H') || state.toLowerCase().contains('live')) return Color(0xFFFF6B6B);
    if (state.toLowerCase().contains('ft') || state.toLowerCase().contains('finished')) return Color(0xFF4CAF50);
    if (state.toLowerCase().contains('ns') || state.toLowerCase().contains('not started')) return Colors.blue;
    return Colors.grey;
  }
}