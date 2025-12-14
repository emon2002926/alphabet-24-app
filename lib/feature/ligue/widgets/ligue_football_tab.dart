import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/s_label.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/leage_list_controller.dart';

import '../../../core/universal_widgets/league_list_widget.dart';
import '../controllers/widget_change_controller.dart';

class LigueFootballTab extends StatefulWidget {
  const LigueFootballTab({super.key});

  @override
  State<LigueFootballTab> createState() => _LigueFootballTabState();
}

class _LigueFootballTabState extends State<LigueFootballTab> {
  @override
  Widget build(BuildContext context) {

    final LeagueListController leagueListController =
    Get.put(LeagueListController());

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: SizedBox(
                height: 60,
                child: STextField(
                    hintText: 'Search League',
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search, color: SColor.primary,)
                ),
              ),
            ),
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
                       'All Games',
                       style: STextTheme.headLine().copyWith(
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                   ),
                   Text(
                     '418',
                     style: STextTheme.headLine().copyWith(
                       fontSize: 14,
                       fontWeight: FontWeight.w500,
                       color: SColor.primary,
                     ),
                   ),
                 ],
               ),
             ),
           ),
            Obx(() {
              if (leagueListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (leagueListController.leagues.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: DynamicSize.small(context)),
                    LeagueListWidget(
                      leagueListController: leagueListController,
                      showDivider: true,
                      itemCount: leagueListController.leagues.length,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            // LeagueListWidget(leagues: leagues),

          ],
        )
      ),
    );
  }


}




