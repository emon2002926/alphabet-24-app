import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/s_label.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';

import '../../../core/universal_widgets/league_list_widget.dart';
import '../controllers/widget_change_controller.dart';

class FavouriteIgueFootballTab extends StatefulWidget {
  const FavouriteIgueFootballTab({super.key});

  @override
  State<FavouriteIgueFootballTab> createState() => _FavouriteIgueFootballTabState();
}

class _FavouriteIgueFootballTabState extends State<FavouriteIgueFootballTab> {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> leagues = [
      {'name': 'Premier League', 'logo': 'assets/images/UEL.png', 'count': 28},
      {'name': 'La Liga', 'logo': 'assets/images/UEL.png', 'count': 24},
      {'name': 'Serie A', 'logo': 'assets/images/UEL.png', 'count': 21},
      {'name': 'Bundesliga', 'logo': 'assets/images/UEL.png', 'count': 19},
      {'name': 'Ligue 1', 'logo': 'assets/images/UEL.png', 'count': 16},
    ];

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
             SLabel(title: 'FAVOURITE COMPETITION',),
            // LeagueListWidget(leagues: leagues),
            SizedBox(height: DynamicSize.large(context),),

          ],
        )
      ),
    );
  }


}




