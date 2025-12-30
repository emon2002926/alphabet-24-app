import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../../home/controllers/sports_data/football_data/football_live_match_controller.dart';
import '../../home/models/live_match_response_model.dart';
import 'package:get/get.dart';

import 'match_details_screen.dart';

class MatchSearchScreen extends StatefulWidget {
  const MatchSearchScreen({super.key});

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreenState();
}

class _MatchSearchScreenState extends State<MatchSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FootballLiveMatchController _controller = Get.find<FootballLiveMatchController>();

  List<LiveMatch> _filteredMatches = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _filterMatches(_searchController.text);
      } else {
        _filteredMatches.clear();
      }
    });
  }

  void _filterMatches(String query) {
    final allMatches = _controller.displayMatches;
    final lowercaseQuery = query.toLowerCase();

    _filteredMatches = allMatches.where((match) {
      // Search in team names
      final homeTeamMatch = match.homeTeam.name.toLowerCase().contains(lowercaseQuery);
      final awayTeamMatch = match.awayTeam.name.toLowerCase().contains(lowercaseQuery);

      // Search in league name
      final leagueMatch = match.league.name.toLowerCase().contains(lowercaseQuery);

      // Search in country name
      final countryMatch = match.league.country.name.toLowerCase().contains(lowercaseQuery);

      // Search in match name
      final matchNameMatch = match.name.toLowerCase().contains(lowercaseQuery);

      return homeTeamMatch || awayTeamMatch || leagueMatch || countryMatch || matchNameMatch;
    }).toList();

    // Sort: live matches first, then by start time
    _filteredMatches.sort((a, b) {
      if (a.status.isLive && !b.status.isLive) return -1;
      if (!a.status.isLive && b.status.isLive) return 1;
      return a.startingAt.compareTo(b.startingAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Search teams, leagues, countries...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[500]),
              onPressed: () {
                _searchController.clear();
              },
            )
                : null,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildBody(isDark),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    if (!_isSearching) {
      return _buildEmptyState(
        icon: Icons.search,
        message: 'Search for teams, leagues, or countries',
        isDark: isDark,
      );
    }

    if (_filteredMatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        message: 'No matches found for "${_searchController.text}"',
        isDark: isDark,
      );
    }

    return Column(
      children: [
        // Results count
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: DynamicSize.medium(context),
            vertical: 12,
          ),
          child: Row(
            children: [
              Text(
                '${_filteredMatches.length} ${_filteredMatches.length == 1 ? 'Match' : 'Matches'} Found',
                style: STextTheme.headLine().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: DynamicSize.small(context)),
            itemCount: _filteredMatches.length,
            itemBuilder: (context, index) {
              return _SearchResultCard(
                match: _filteredMatches[index],
                query: _searchController.text,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required bool isDark,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              style: STextTheme.headLine().copyWith(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Search Result Card Widget
class _SearchResultCard extends StatelessWidget {
  final LiveMatch match;
  final String query;

  const _SearchResultCard({
    required this.match,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPeriod = match.periods.isNotEmpty;
    final periodMinutes = hasPeriod ? match.periods[0].minutes : 0;

    return GestureDetector(
      onTap: () => Get.to(
        MatchDetailsScreen(),
        arguments: {'matchId': match.id},
      ),
      child: Card(
        color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFFFFFFF),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // League Info
              Row(
                children: [
                  Image.network(
                    match.league.logo,
                    height: 16,
                    width: 16,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.sports_soccer,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.league.name,
                      style: STextTheme.subHeadLine().copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Status badge
                  if (match.status.isLive)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'LIVE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    )
                  else
                    Text(
                      DateFormat('HH:mm').format(match.startingAt),
                      style: STextTheme.subHeadLine().copyWith(
                        fontSize: 11,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Teams and Score
              Row(
                children: [
                  // Home Team
                  Expanded(
                    child: Row(
                      children: [
                        Image.network(
                          match.homeTeam.logo,
                          height: 24,
                          width: 24,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.sports_soccer,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            match.homeTeam.name,
                            style: STextTheme.headLine().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      match.score.display,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: match.status.isLive ? Colors.red : null,
                      ),
                    ),
                  ),

                  // Away Team
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.awayTeam.name,
                            style: STextTheme.headLine().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          match.awayTeam.logo,
                          height: 24,
                          width: 24,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.sports_soccer,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Minute indicator for live matches
              if (match.status.isLive && hasPeriod) ...[
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$periodMinutes' - ${match.periods[0].description}",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}