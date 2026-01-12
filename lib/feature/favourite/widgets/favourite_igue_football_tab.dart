import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

import '../../home/models/live_match_response_model.dart';
import '../../match/views/match_details_screen.dart';
import '../controllers/favourite_controller.dart';

class FavouriteIgueFootballTab extends StatelessWidget {
  const FavouriteIgueFootballTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchFavourites(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final leagues = controller.filteredLeagues;
                  final fixtures = controller.filteredFixtures;

                  // Check if both are empty
                  if (leagues.isEmpty && fixtures.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.favorite_border, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No favourites yet',
                              style: STextTheme.subHeadLine().copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Build list of all match groups (from both leagues and fixtures)
                  return Column(
                    children: [
                      // ===== LEAGUES WITH MATCHES =====
                      ...leagues.where((league) => league.matches.isNotEmpty).map((league) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                          child: _LeagueMatchesGroup(
                            leagueName: league.leagueName,
                            leagueLogo: league.leagueLogo,
                            matches: league.matches,
                            onRemoveMatch: (matchId) => controller.removeFixtureFavourite(matchId),
                          ),
                        );
                      }),

                      // ===== STANDALONE FIXTURES =====
                      if (fixtures.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                          child: _buildFixturesSection(fixtures, controller),
                        ),
                      ],

                      SizedBox(height: DynamicSize.large(context)),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFixturesSection(List<FavouriteFixture> fixtures, FavouriteController controller) {
    // Group fixtures by league
    final groupedFixtures = _groupFixturesByLeague(fixtures);

    return Column(
      children: groupedFixtures.entries.map((entry) {
        final leagueName = entry.key;
        final leagueFixtures = entry.value;
        final leagueLogo = leagueFixtures.first.league.logo;

        return _FixturesMatchGroup(
          leagueName: leagueName,
          leagueLogo: leagueLogo,
          fixtures: leagueFixtures,
          onRemoveFixture: (fixture) => controller.removeFixtureFavourite(fixture.id),
        );
      }).toList(),
    );
  }

  Map<String, List<FavouriteFixture>> _groupFixturesByLeague(List<FavouriteFixture> fixtures) {
    final Map<String, List<FavouriteFixture>> grouped = {};

    for (final fixture in fixtures) {
      final leagueName = fixture.league.name;
      if (!grouped.containsKey(leagueName)) {
        grouped[leagueName] = [];
      }
      grouped[leagueName]!.add(fixture);
    }

    return grouped;
  }
}

// ===== WIDGET FOR LEAGUE MATCHES (from leagues array) =====
class _LeagueMatchesGroup extends StatelessWidget {
  final String leagueName;
  final String leagueLogo;
  final List<dynamic> matches;
  final Function(int) onRemoveMatch;

  const _LeagueMatchesGroup({
    required this.leagueName,
    required this.leagueLogo,
    required this.matches,
    required this.onRemoveMatch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // League Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  leagueLogo,
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.sports_soccer,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                leagueName,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Match Cards
        ...matches.map((match) => _LeagueMatchCard(
          match: match,
          onRemove: () => onRemoveMatch(match['id'] ?? 0),
        )),
      ],
    );
  }
}

// ===== WIDGET FOR STANDALONE FIXTURES GROUP =====
class _FixturesMatchGroup extends StatelessWidget {
  final String leagueName;
  final String leagueLogo;
  final List<FavouriteFixture> fixtures;
  final Function(FavouriteFixture) onRemoveFixture;

  const _FixturesMatchGroup({
    required this.leagueName,
    required this.leagueLogo,
    required this.fixtures,
    required this.onRemoveFixture,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // League Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  leagueLogo,
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.sports_soccer,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                leagueName,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Match Cards for Fixtures
        ...fixtures.map((fixture) => FavouriteMatchCard(
          fixture: fixture,
          onRemove: () => onRemoveFixture(fixture),
        )),
      ],
    );
  }
}

// ===== MATCH CARD FOR LEAGUE MATCHES =====
// ===== MATCH CARD FOR LEAGUE MATCHES =====
class _LeagueMatchCard extends StatelessWidget {
  final dynamic match;
  final VoidCallback onRemove;

  const _LeagueMatchCard({
    required this.match,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ===== EXTRACT DATA FROM MATCH =====
    final matchId = match['id'] ?? 0;
    final matchName = match['name'] ?? '';
    final startingAt = DateTime.tryParse(match['starting_at'] ?? '') ?? DateTime.now();

    final status = match['status'] ?? {};
    final isLive = status['is_live'] ?? false;
    final stateShort = status['state_short'] ?? 'NS';
    final minute = isLive ? (status['minute'] ?? 0) : null;

    final homeTeam = match['home_team'] ?? {};
    final awayTeam = match['away_team'] ?? {};

    // ===== PREDICTION VALUES =====
    final predictions = match['predictions'];
    final hasPredictions = predictions != null;

    final homeProb = hasPredictions ? (predictions['fulltime_result']?['home_win'] ?? 33.0).toDouble() : 33.0;
    final drawProb = hasPredictions ? (predictions['fulltime_result']?['draw'] ?? 33.0).toDouble() : 33.0;
    final awayProb = hasPredictions ? (predictions['fulltime_result']?['away_win'] ?? 33.0).toDouble() : 33.0;
    final overProb = hasPredictions ? (predictions['over_under_2_5']?['over'] ?? 50.0).toDouble() : 50.0;
    final underProb = hasPredictions ? (predictions['over_under_2_5']?['under'] ?? 50.0).toDouble() : 50.0;

    return GestureDetector(
      onTap: () => Get.to(
        MatchDetailsScreen(),
        arguments: {'matchId': matchId},
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== TOP ROW: TIME/STATUS & FAVORITE =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live minute or start time
                  if (isLive && minute != null)
                    Text(
                      "$minute'",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    )
                  else if (stateShort == 'FT')
                    Text(
                      'FT',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    )
                  else
                    Text(
                      DateFormat('HH:mm').format(startingAt),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SColor.primary,
                      ),
                    ),
                  // Favorite button
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ===== HOME TEAM ROW =====
              _buildTeamRow(
                logo: homeTeam['logo'] ?? '',
                name: homeTeam['name'] ?? '',
                score: homeTeam['score'] ?? 0,
                showScore: stateShort == 'FT' || isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 6),

              // ===== AWAY TEAM ROW =====
              _buildTeamRow(
                logo: awayTeam['logo'] ?? '',
                name: awayTeam['name'] ?? '',
                score: awayTeam['score'] ?? 0,
                showScore: stateShort == 'FT' || isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 10),

              // ===== PREDICTION BOXES (1, X, 2) =====
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    // Home Win (1)
                    Expanded(
                      flex: homeProb.round().clamp(15, 100),
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
                      flex: drawProb.round().clamp(15, 100),
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
                      flex: awayProb.round().clamp(15, 100),
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

              const SizedBox(height: 8),

              // ===== OVER/UNDER 2.5 BOXES =====
              SizedBox(
                height: 30,
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
    required bool showScore,
    required bool isDark,
  }) {
    return Row(
      children: [
        // Team logo
        Image.network(
          logo,
          height: 22,
          width: 22,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sports_soccer,
            size: 22,
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
          showScore ? score.toString() : '-',
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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

class FavouriteMatchCard extends StatelessWidget {
  final FavouriteFixture fixture;
  final VoidCallback onRemove;

  const FavouriteMatchCard({
    required this.fixture,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ===== PREDICTION VALUES =====
    final hasPredictions = fixture.predictions != null;
    final homeProb = hasPredictions ? fixture.predictions!.fulltimeResult.homeWin : 33.0;
    final drawProb = hasPredictions ? fixture.predictions!.fulltimeResult.draw : 33.0;
    final awayProb = hasPredictions ? fixture.predictions!.fulltimeResult.awayWin : 33.0;
    final overProb = hasPredictions ? fixture.predictions!.overUnder25.over : 50.0;
    final underProb = hasPredictions ? fixture.predictions!.overUnder25.under : 50.0;

    return GestureDetector(
      onTap: () => Get.to(
        MatchDetailsScreen(),
        arguments: {'matchId': fixture.id},
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== TOP ROW: TIME/STATUS & FAVORITE =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live minute or start time
                  if (fixture.isLive && fixture.minute != null)
                    Text(
                      "${fixture.minute}'",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    )
                  else if (fixture.stateShort == 'FT')
                    Text(
                      'FT',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    )
                  else
                    Text(
                      DateFormat('HH:mm').format(fixture.startingAt),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SColor.primary,
                      ),
                    ),
                  // Favorite button
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ===== HOME TEAM ROW =====
              _buildTeamRow(
                logo: fixture.homeTeam.logo,
                name: fixture.homeTeam.name,
                score: fixture.homeTeam.score ?? 0,
                showScore: fixture.stateShort == 'FT' || fixture.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 6),

              // ===== AWAY TEAM ROW =====
              _buildTeamRow(
                logo: fixture.awayTeam.logo,
                name: fixture.awayTeam.name,
                score: fixture.awayTeam.score ?? 0,
                showScore: fixture.stateShort == 'FT' || fixture.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 10),

              // ===== PREDICTION BOXES (1, X, 2) =====
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    // Home Win (1)
                    Expanded(
                      flex: homeProb.round().clamp(15, 100),
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
                      flex: drawProb.round().clamp(15, 100),
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
                      flex: awayProb.round().clamp(15, 100),
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

              const SizedBox(height: 8),

              // ===== OVER/UNDER 2.5 BOXES =====
              SizedBox(
                height: 30,
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
    required bool showScore,
    required bool isDark,
  }) {
    return Row(
      children: [
        // Team logo
        Image.network(
          logo,
          height: 22,
          width: 22,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sports_soccer,
            size: 22,
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
          showScore ? score.toString() : '-',
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
