import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';

import '../../../core/sample_data/sample_data.dart';
import '../../../core/universal_widgets/news_card_widget.dart';
import '../../../core/universal_widgets/scoure_card_widget.dart';
import '../../../core/universal_widgets/searchbar.dart';

class PredictedFootballTab extends StatefulWidget {
  const PredictedFootballTab({super.key});

  @override
  State<PredictedFootballTab> createState() => _PredictedFootballTabState();
}

class _PredictedFootballTabState extends State<PredictedFootballTab> {
  final TextEditingController searchController = TextEditingController();
  final FootballLiveMatchController footballLiveMatchController =
  Get.put(FootballLiveMatchController());

  // ===== DEV FLAG - Set to false for production =====
  static const bool _useSampleData = false; // <-- CONTROL THIS

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

        final hasLiveMatches = footballLiveMatchController.liveMatches.isNotEmpty;

        /// Empty state (when not using sample data)
        if (!hasLiveMatches && !_useSampleData) {
          return const Center(
            child: Text(
              "No Live matches available for prediction",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          );
        }

        /// Build matches list
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(DynamicSize.small(context)),
            child:Column(
              children: [
                SearchWidget(
                  controller: searchController,
                  onChanged: (value) {
                    print('Searching: $value');
                    // Filter matches based on search
                  },
                  onSubmitted: (value) {
                    print('Search submitted: $value');
                    // Perform search action
                  },
                  hintText: 'Search Your match',
                ),
                SizedBox(height: DynamicSize.small(context)),
                hasLiveMatches
                    ? _buildLiveMatchesList()
                    : (_useSampleData ? _buildSampleMatchesList() : SizedBox.shrink()),
              ],
            )
          ),
        );
      }),
    );
  }

  /// Build live matches list
  Widget _buildLiveMatchesList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: footballLiveMatchController.liveMatches.length,
      itemBuilder: (context, index) {
        return ScoureCardWidget(index: index,shrink: true,);
      },
    );
  }

  /// Build sample matches list
  Widget _buildSampleMatchesList() {

    final sampleMatches = SampleLiveMatchData.getSampleData().matches;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sampleMatches.length,
      itemBuilder: (context, index) {
        return ScoureCardWidget(match: sampleMatches[index]);
      },
    );
  }
}



