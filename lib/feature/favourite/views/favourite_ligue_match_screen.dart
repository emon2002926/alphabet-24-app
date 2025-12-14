import 'package:flutter/material.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import 'package:scaffassistant/feature/prediction/widgets/predicted_football_tab.dart';

import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../../home/widgets/football_screen.dart';
import '../widgets/favourite_igue_football_tab.dart';

class FavouriteLigueMatchScreen extends StatelessWidget {
  const FavouriteLigueMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'All Ligue', isHomeScreen: true),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------- Tab Bar ----------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DynamicSize.medium(context),
                  vertical: DynamicSize.small(context),
                ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: SColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.zero,
                    indicator: BoxDecoration(
                      color: SColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: SColor.primary,
                    splashBorderRadius: BorderRadius.circular(12),
                    tabs: const [
                      Tab(text: 'Football'),
                      Tab(text: 'Basketball'),
                      Tab(text: 'Tennis'),
                    ],
                  ),
                ),
              ),


              // ---------- Horizontal Date Header ----------
              SizedBox(
                height: 70,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: DynamicSize.medium(context),
                    vertical: DynamicSize.small(context),
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final dayName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][index];
                    final date = (1.10 + index * 0.01).toStringAsFixed(2);
                    return Padding(
                      padding: EdgeInsets.only(right: DynamicSize.medium(context)),
                      child: Container(
                        width: 60,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayName,
                                style: STextTheme.headLine().copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                date,
                                style: STextTheme.headLine().copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ---------- TabBar View ----------
              Expanded(
                child: TabBarView(
                  children: const [
                    FavouriteIgueFootballTab(),
                    Center(child: Text("🏀 Basketball Coming Soon")),
                    Center(child: Text("🎾 Tennis Coming Soon")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
