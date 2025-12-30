import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/basketball/basketball_leagues_controller.dart';
import 'package:scaffassistant/feature/ligue/views/ligue_match_list_screen.dart';

class BasketballLigueListScreen extends StatelessWidget {
  final BasketballLeaguesController controller;
  final bool showDivider;
  final int? itemCount;

  const BasketballLigueListScreen({
    super.key,
    required this.controller,
    this.showDivider = true,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'All Ligue'),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.basketballLeagues.isEmpty) {
            return const Center(child: Text("No leagues available"));
          }

          return ListView.separated(
            itemCount: itemCount ?? controller.basketballLeagues.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) =>
            showDivider ? const Divider(color: Colors.grey, height: 1) : const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final league = controller.basketballLeagues[index];

              print('League: ${league.name}, ID: ${league.id}');

              return GestureDetector(
                onTap: () {
                  Get.to(() => LigueMatchListScreen(), arguments: {
                    'leagueId': league.id ?? 0,
                    'leagueName': league.name ?? 'Unknown League',
                  });
                },
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: (league.logo != null && league.logo!.isNotEmpty)
                              ? Image.network(
                            league.logo!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.sports_basketball, size: 24, color: Colors.grey[600]),
                              );
                            },
                          )
                              : Center(
                            child: Icon(Icons.sports_basketball, size: 24, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              league.name ?? 'Unknown League',
                              style: STextTheme.subHeadLine().copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              league.type ?? '-',
                              style: STextTheme.headLine().copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
