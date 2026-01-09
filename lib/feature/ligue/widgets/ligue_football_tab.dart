import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/leage_list_controller.dart';

import '../../../core/universal_widgets/league_list_widget.dart';
import '../views/ligue_match_list_screen.dart';
import 'date_selector_widget.dart';

class LeaguesFootballTab extends StatelessWidget {
  final bool isShowSearch;
  final int? totalLig;
  const LeaguesFootballTab({super.key, required this.isShowSearch, this.totalLig});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Use Get.find() if controller already exists, or put with permanent
    final LeagueListController leagueListController = Get.put(
      LeagueListController(),
      permanent: true, // ✅ Keeps controller alive across rebuilds
    );

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          DateSelectorWidget(),
          isShowSearch
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
            child: SizedBox(
              height: 60,
              child: STextField(
                hintText: 'Search League',
                labelText: 'Search',
                controller: searchController,
                onChanged: (value) => leagueListController.updateSearch(value),
                suffixIcon: Obx(() => GestureDetector(
                  onTap: () {
                    if (leagueListController.searchQuery.value.isNotEmpty) {
                      searchController.clear();
                      leagueListController.clearSearch();
                    }
                  },
                  child: Icon(
                    leagueListController.searchQuery.value.isNotEmpty
                        ? Icons.close
                        : Icons.search,
                    color: SColor.primary,
                  ),
                )),
              ),
            ),
          ) : SizedBox.shrink(),

          // Filter Row
          isShowSearch
              ? Padding(
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
                      'All Games',
                      style: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Obx(() => Text(
                    '${leagueListController.leagueByDateResponse.value?.totalMatches}',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: SColor.primary,
                    ),
                  )),
                ],
              ),
            ),
          ) : SizedBox.shrink(),

          // League List
          Expanded(
            child: Obx(() {
              if (leagueListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (leagueListController.filteredLeagues.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        leagueListController.searchQuery.value.isNotEmpty
                            ? 'No leagues found for "${leagueListController.searchQuery.value}"'
                            : 'No leagues available',
                        style: STextTheme.subHeadLine().copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => leagueListController.fetchLeaguesByDate(
                  leagueListController.selectedDate.value,
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: DynamicSize.small(context)),
                      LeagueListWidget(
                        leagues: leagueListController.filteredLeagues,
                        showDivider: true,
                        totalLig: totalLig,
                        onToggleFavorite: (index, league) {
                          leagueListController.toggleFavoriteLeague(
                            index,
                            useFiltered: true,
                          );
                        },
                        onLeagueTap: (league) {
                          Get.to(() => LigueMatchListScreen(), arguments: {
                            'leagueId': league.id,
                            'leagueName': league.name,
                            'PrimaryLeagueList': league.matches
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

