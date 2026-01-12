import 'package:flutter/material.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import '../widgets/ligue_basketball_tab.dart';
import '../widgets/ligue_football_tab.dart';

class LigueScreen extends StatelessWidget {
  const LigueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'All Ligues', isHomeScreen: true),
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
                      // Tab(text: 'Tennis'),
                    ],
                  ),
                ),
              ),


              Expanded(
                child: TabBarView(
                  children: const [
                    LeaguesFootballTab(isShowSearch: true),
                    LigueBasketballTab(),
                    // DevelopmentPage(),
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

