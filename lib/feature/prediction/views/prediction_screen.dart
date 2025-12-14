import 'package:flutter/material.dart';
import 'package:scaffassistant/feature/home/screens/home_screen.dart';
import 'package:scaffassistant/feature/prediction/widgets/predicted_basketball_tab.dart';
import 'package:scaffassistant/feature/prediction/widgets/predicted_football_tab.dart';

import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/universal_widgets/appbar.dart';
import '../../home/widgets/football_screen.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'Live Match Prediction', isHomeScreen: true),
      body: SafeArea(
        top: true,
        bottom: true,
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context), vertical: DynamicSize.medium(context)),
                child: Container(
                  height: 35,
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
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    PredictedFootballTab(),
                    PredictedBasketballTab(),
                    DevelopmentPage(),
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
