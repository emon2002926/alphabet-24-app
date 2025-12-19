import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import '../../feature/home/controllers/sports_data/football_data/leage_list_controller.dart';
import '../../feature/home/models/leage_list_model.dart';
import '../../feature/ligue/views/ligue_match_list_screen.dart';

class LeagueListWidget extends StatelessWidget {
  final LeagueListController leagueListController;
  final bool showDivider;
  final int itemCount;
  final bool useFilteredList;

  const LeagueListWidget({
    required this.leagueListController,
    this.showDivider = false,
    required this.itemCount,
    this.useFilteredList = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final leagues = useFilteredList
          ? leagueListController.filteredLeagues
          : leagueListController.leagues;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final league = leagues[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // Navigate to league details
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // ===== FAVORITE BUTTON =====
                      GestureDetector(
                        onTap: () => leagueListController.toggleFavoriteLeague(
                          index,
                          useFiltered: useFilteredList,
                        ),
                        child: Icon(
                          league.isFavorite ? Icons.star : Icons.star_border,
                          color: league.isFavorite ? Colors.amber : Colors.grey,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ===== LEAGUE LOGO =====
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          league.logo,
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

                      // ===== LEAGUE INFO =====
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              league.name,
                              style: STextTheme.headLine().copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              league.country.name,
                              style: STextTheme.subHeadLine().copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===== ARROW ICON =====
                      // Icon(
                      //   Icons.chevron_right,
                      //   color: Colors.grey[400],
                      //   size: 24,
                      // ),
                    ],
                  ),
                ),
              ),
              if (showDivider)
                Divider(height: 1, color: Colors.grey[300], indent: 48),
            ],
          );
        },
      );
    });
  }
}