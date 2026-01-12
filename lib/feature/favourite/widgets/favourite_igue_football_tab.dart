import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

import '../../home/models/live_match_response_model.dart';
import '../../ligue/views/ligue_match_list_screen.dart';
import '../../match/views/match_details_screen.dart';
import '../controllers/favourite_controller.dart';

class FavouriteIgueFootballTab extends StatelessWidget {
  const FavouriteIgueFootballTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());
    final TextEditingController searchController = TextEditingController();

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
                  if (leagues.isEmpty) return const SizedBox.shrink();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                    itemCount: leagues.length,
                    itemBuilder: (context, index) {
                      return FavouriteLeagueCard(
                        league: leagues[index],
                        onTap: () {
                          Get.to(() => LigueMatchListScreen(), arguments: {
                            'leagueId': leagues[index].leagueId,
                            'leagueName': leagues[index].leagueName,
                          });
                        },
                        onRemove: () => controller.removeLeagueFavourite(leagues[index].leagueId),
                      );
                    },
                  );
                }),

                Obx(() {
                  final fixtures = controller.filteredFixtures;

                  if (fixtures.isEmpty && controller.filteredLeagues.isEmpty) {
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

                  if (fixtures.isEmpty) return const SizedBox.shrink();

                  // Group fixtures by league
                  final groupedFixtures = _groupFixturesByLeague(fixtures);

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                    itemCount: groupedFixtures.length,
                    itemBuilder: (context, index) {
                      final leagueName = groupedFixtures.keys.elementAt(index);
                      final leagueFixtures = groupedFixtures[leagueName]!;
                      final leagueLogo = leagueFixtures.first.league.logo;

                      return FavouriteLeagueMatchGroup(
                        leagueName: leagueName,
                        leagueLogo: leagueLogo,
                        fixtures: leagueFixtures,
                        onRemoveFixture: (fixture) => controller.removeFixtureFavourite(fixture.id),
                      );
                    },
                  );
                }),

                SizedBox(height: DynamicSize.large(context)),
              ],
            ),
          ),
        );
      }),
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


// ===== FAVOURITE LEAGUE CARD =====
class FavouriteLeagueCard extends StatelessWidget {
  final FavouriteLeague league;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavouriteLeagueCard({
    required this.league,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // League Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                league.leagueLogo,
                height: 28,
                width: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.sports_soccer, size: 16, color: Colors.grey[600]),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // League Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    league.leagueName,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'No Matches Today',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Favorite Star Icon
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.star_border,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== FAVOURITE LEAGUE MATCH GROUP =====
class FavouriteLeagueMatchGroup extends StatelessWidget {
  final String leagueName;
  final String leagueLogo;
  final List<FavouriteFixture> fixtures;
  final Function(FavouriteFixture) onRemoveFixture;

  const FavouriteLeagueMatchGroup({
    required this.leagueName,
    required this.leagueLogo,
    required this.fixtures,
    required this.onRemoveFixture,
    super.key,
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
        ...fixtures.map((fixture) => FavouriteMatchCard(
          fixture: fixture,
          onRemove: () => onRemoveFixture(fixture),
        )),
      ],
    );
  }
}

// ===== FAVOURITE MATCH CARD =====
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    )
                  else if (fixture.stateShort == 'FT')
                    Text(
                      'FT',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    )
                  else
                    Text(
                      DateFormat('h:mma').format(fixture.startingAt).toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  // Favorite button
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.star_border,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== HOME TEAM ROW =====
              _buildTeamRow(
                logo: fixture.homeTeam.logo,
                name: fixture.homeTeam.name,
                score: fixture.homeTeam.score,
                showScore: fixture.stateShort == 'FT' || fixture.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 8),

              // ===== AWAY TEAM ROW =====
              _buildTeamRow(
                logo: fixture.awayTeam.logo,
                name: fixture.awayTeam.name,
                score: fixture.awayTeam.score,
                showScore: fixture.stateShort == 'FT' || fixture.isLive,
                isDark: isDark,
              ),

              const SizedBox(height: 12),

              // ===== PREDICTION BOXES (1, X, 2) =====
              SizedBox(
                height: 32,
                child: Row(
                  children: [
                    // Home Win (1)
                    Expanded(
                      flex: homeProb.round().clamp(1, 100),
                      child: _buildPredictionBox(
                        label: '1',
                        percentage: homeProb,
                        color: const Color(0xFF0096C7),
                        textColor: Colors.white,
                        percentageColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
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
                    const SizedBox(width: 4),
                    // Away Win (2)
                    Expanded(
                      flex: awayProb.round().clamp(1, 100),
                      child: _buildPredictionBox(
                        label: '2',
                        percentage: awayProb,
                        color: const Color(0xFF01002A),
                        textColor: Colors.white,
                        percentageColor: const Color(0xFF0096C6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ===== OVER/UNDER 2.5 BOXES =====
              SizedBox(
                height: 32,
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
                    const SizedBox(width: 8),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            logo,
            height: 24,
            width: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.sports_soccer, size: 14, color: Colors.grey[600]),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Team name
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Score
        Text(
          showScore ? score.toString() : '',
          style: GoogleFonts.roboto(
            fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: percentageColor ?? textColor,
              ),
              overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF015440),
            ),
          ),
        ],
      ),
    );
  }
}

