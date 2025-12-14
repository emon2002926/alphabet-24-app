import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import '../../feature/home/controllers/sports_data/football_data/leage_list_controller.dart';
import '../../feature/home/models/leage_list_model.dart';
import '../../feature/ligue/views/ligue_match_list_screen.dart';

class LeagueListWidget extends StatelessWidget {
  final LeagueListController leagueListController;
  final bool showDivider;
  final int? itemCount;

  const LeagueListWidget({
    super.key,
    required this.leagueListController,
    this.showDivider = true,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {


    return Obx(() {
      if (leagueListController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (leagueListController.leagues.isEmpty) {
        return const Center(child: Text("No leagues available"));
      }

      return ListView.separated(
        itemCount: itemCount ?? leagueListController.leagues.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => showDivider
            ? const Divider(color: Colors.grey, height: 1)
            : const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final League league = leagueListController.leagues[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => LigueMatchListScreen(),arguments: {
                'leagueId': league.id,
                'leagueName': league.name,
              });
            },
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      league.logo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.sports_soccer, size: 24);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name section
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          league.name,
                          style: STextTheme.subHeadLine().copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          league.shortCode,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Country flag section
                  if (league.country.flag.isNotEmpty)
                    Container(
                      width: 30,
                      height: 20,
                      margin: const EdgeInsets.only(left: 8),
                      child: Image.network(
                        league.country.flag,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox();
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
