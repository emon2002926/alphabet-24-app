import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/match/views/match_details_screen.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/universal_widgets/appbar.dart';
import '../controllers/league_detail_controller.dart';
import '../models/league_detail_response.dart';

class LigueMatchListScreen extends StatelessWidget {
  LigueMatchListScreen({super.key});

  late final LeagueDetailController controller;

  @override
  Widget build(BuildContext context) {
    final int leagueId = Get.arguments['leagueId'] as int;
    controller = Get.put(LeagueDetailController(leagueId: leagueId));

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'Ligue Matches'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.liveMatches.isEmpty && controller.todayFixtures.isEmpty) {
          return const Center(child: Text('No matches today'));
        }

        return ListView(
          padding: EdgeInsets.all(DynamicSize.medium(context)),
          children: [
            if (controller.liveMatches.isNotEmpty) ...[
              const Text('Live Matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.liveMatches
                  .map((match) => _buildMatchRow(match, context))
                  ,
              SizedBox(height: DynamicSize.medium(context)),
            ],
            if (controller.todayFixtures.isNotEmpty) ...[
              const Text('Today\'s Fixtures',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: DynamicSize.small(context)),
              ...controller.todayFixtures
                  .map((match) => _buildMatchRow(match, context))
                  ,
            ],
          ],
        );
      }),
    );
  }

  Widget _buildMatchRow(LeagueMatch match, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(MatchDetailsScreen(),arguments: {
          'matchId': match.id,
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: DynamicSize.medium(context)),
        padding: EdgeInsets.all(DynamicSize.small(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to match details
              },
              child: Icon(Icons.star_border, color: Colors.blue),
            ),
            SizedBox(width: DynamicSize.small(context)),
            Expanded(child: Column(
              children: [
                Row(
                  children: [
                    Image.network(match.homeTeam.logo, width: 30, height: 30),
                    SizedBox(height: 4),
                    Text(match.homeTeam.name, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Image.network(match.awayTeam.logo, width: 30, height: 30),
                    SizedBox(height: 4),
                    Text(match.awayTeam.name, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
              ),
            ),
            Text(
              match.state.isNotEmpty ? match.state : match.startingAt,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
