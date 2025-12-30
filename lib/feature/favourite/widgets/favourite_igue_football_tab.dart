import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/s_label.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';

import '../../home/models/live_match_response_model.dart';
import '../../ligue/views/ligue_match_list_screen.dart';
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
                // Search Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                  child: SizedBox(
                    height: 60,
                    child: STextField(
                      hintText: 'Search',
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search, color: SColor.primary),
                      onChanged: (value) => controller.updateSearch(value),
                    ),
                  ),
                ),

                // Filter Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.filter_list, color: SColor.primary),
                        SizedBox(width: DynamicSize.small(context)),
                        Expanded(
                          child: Text(
                            'All Favourites',
                            style: STextTheme.headLine().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Obx(() => Text(
                          '${controller.totalFavourites.value}',
                          style: STextTheme.headLine().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: SColor.primary,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),

                // ===== FAVOURITE LEAGUES SECTION =====
                Obx(() {
                  final leagues = controller.filteredLeagues;
                  if (leagues.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SLabel(title: 'FAVOURITE LEAGUES'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                        itemCount: leagues.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap:() {
                              Get.to(() => LigueMatchListScreen(),arguments: {
                                'leagueId': leagues[index].id,
                                'leagueName': leagues[index].leagueName,
                              });
                            },
                            child: FavouriteLeagueCard(
                              league: leagues[index],
                              onRemove: () => controller.removeLeagueFavourite(leagues[index].id),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),

                // ===== FAVOURITE MATCHES SECTION =====
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SLabel(title: 'FAVOURITE MATCHES'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                        itemCount: fixtures.length,
                        itemBuilder: (context, index) {
                          return FavouriteMatchCard(
                            fixture: fixtures[index],
                            onRemove: () => controller.removeFixtureFavourite(fixtures[index].id),
                          );
                        },
                      ),
                    ],
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(
            MatchDetailsScreen(),
            arguments: {'matchId': fixture.fixtureId},
          );
        },
        child: Row(
          children: [
            // Favorite Star Icon
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            // Team Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home Team
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.sports_soccer, size: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fixture.homeTeam,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Away Team
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.sports_soccer, size: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fixture.awayTeam,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(fixture.fixtureDate),
                  style: STextTheme.subHeadLine().copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(fixture.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    fixture.status,
                    style: STextTheme.subHeadLine().copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(fixture.status),
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

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'LIVE':
      case '1H':
      case '2H':
      case 'HT':
        return Colors.green;
      case 'FT':
        return Colors.blue;
      case 'NS':
        return Colors.orange;
      case 'PST':
      case 'CANC':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
class FavouriteLeagueCard extends StatelessWidget {
  final FavouriteLeague league;
  final VoidCallback onRemove;

  const FavouriteLeagueCard({
    required this.league,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Favorite Star Icon
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.star,
              color: Colors.amber,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // League Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              league.leagueLogo,
              height: 32,
              width: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 32,
                width: 32,
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
                  style: STextTheme.headLine().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  league.leagueCountry,
                  style: STextTheme.subHeadLine().copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Arrow Icon
          // Icon(
          //   Icons.chevron_right,
          //   color: Colors.grey[400],
          //   size: 24,
          // ),
        ],
      ),
    );
  }
}



