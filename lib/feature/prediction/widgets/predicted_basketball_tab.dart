import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';

import '../../../core/universal_widgets/news_card_widget.dart';
import '../../../core/universal_widgets/scoure_card_widget.dart';

class PredictedBasketballTab extends StatefulWidget {
  const PredictedBasketballTab({super.key});

  @override
  State<PredictedBasketballTab> createState() => _PredictedBasketballTabState();
}

class _PredictedBasketballTabState extends State<PredictedBasketballTab> {

  final FootballLiveMatchController footballLiveMatchController = Get.put(FootballLiveMatchController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: Obx(() {

        /// Loading state
        if (footballLiveMatchController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// Empty state
        if (footballLiveMatchController.liveMatches.isEmpty) {
          return const Center(
            child: Text(
              "No predicted matches available",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          );
        }

        /// Data available
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(DynamicSize.small(context)),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: footballLiveMatchController.liveMatches.length,
              itemBuilder: (context, index) {
                return ScoureCardWidget(index: index);
              },
            ),
          ),
        );
      }),
    );
  }
}