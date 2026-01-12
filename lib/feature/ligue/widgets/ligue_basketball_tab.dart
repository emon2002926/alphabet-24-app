import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/basketball/basketball_league_list_widget.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/basketball/basketball_leagues_controller.dart';


class LigueBasketballTab extends StatefulWidget {
  const LigueBasketballTab({super.key});

  @override
  State<LigueBasketballTab> createState() => _LigueBasketballTabState();
}

class _LigueBasketballTabState extends State<LigueBasketballTab> {
  @override
  Widget build(BuildContext context) {

    final BasketballLeaguesController leagueListController =
    Get.put(BasketballLeaguesController());

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
                       style: STextTheme.headLineBold().copyWith(
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                   ),
                   Text(
                     '418',
                     style: STextTheme.headLineBold().copyWith(
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
              } else if (leagueListController.basketballLeagues.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: DynamicSize.small(context)),
                    BasketballLeagueListWidget(controller: leagueListController ),
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




