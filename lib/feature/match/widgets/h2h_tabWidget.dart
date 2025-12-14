import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/head_to_head_controller.dart';

class H2H extends StatefulWidget {
  final int fixtureId;

  const H2H({super.key, required this.fixtureId});

  @override
  State<H2H> createState() => _H2HState();
}

class _H2HState extends State<H2H> {
  final HeadToHeadController controller = Get.put(HeadToHeadController());

  @override
  void initState() {
    super.initState();
    controller.loadH2H(widget.fixtureId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      final data = controller.h2hData.value;
      if (data == null) return Center(child: Text("No data available"));

      final home = data.data.homeTeam;
      final away = data.data.awayTeam;
      final matches = data.data.matches;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleLabel("Last Games: ${home.name}"),
            matchList(matches, controller.expandHome),
            seeMoreButton(controller.expandHome),

            titleLabel("Last Games: ${away.name}"),
            matchList(matches, controller.expandAway),
            seeMoreButton(controller.expandAway),
          ],
        ),
      );
    });
  }

  // ------------------ UI Components ------------------

  Widget titleLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget matchList(List matches, RxBool expand) {
    // Show 2 by default, or all if expanded
    int count = expand.value ? matches.length : (matches.length >= 2 ? 2 : matches.length);

    return ListView.separated(
      itemCount: count,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, index) {
        final match = matches[index];
        final homeTeam = match['home_team']?['name'] ?? "Home";
        final awayTeam = match['away_team']?['name'] ?? "Away";
        final homeScore = match['scores']?['home']?.toString() ?? "0";
        final awayScore = match['scores']?['away']?.toString() ?? "0";
        final date = match['date'] ?? "N/A";

        int home = int.tryParse(homeScore) ?? 0;
        int away = int.tryParse(awayScore) ?? 0;

        String result;
        if (home == away) {
          result = "D";
        } else if (home > away) {
          result = "W";
        } else {
          result = "L";
        }


        return matchCard(
          date: date,
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          homeScore: homeScore,
          awayScore: awayScore,
          result: result,
        );
      },
    );
  }

  Widget matchCard({
    required String date,
    required String homeTeam,
    required String awayTeam,
    required String homeScore,
    required String awayScore,
    required String result,
  }) {
    Color resultColor;
    switch (result) {
      case "W":
        resultColor = Colors.green;
        break;
      case "L":
        resultColor = Colors.red;
        break;
      default:
        resultColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(fontSize: 12)),
          Expanded(
            child: Column(
              children: [
                rowTeam(homeTeam, homeScore),
                SizedBox(height: 8),
                rowTeam(awayTeam, awayScore),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(result, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget rowTeam(String team, String score) {
    return Row(
      children: [
        Icon(Icons.shield, size: 22),
        SizedBox(width: 8),
        Text(team, style: TextStyle(fontWeight: FontWeight.w600)),
        Spacer(),
        Text(score),
      ],
    );
  }

  Widget seeMoreButton(RxBool expandControl) {
    return expandControl.value
        ? SizedBox.shrink()
        : GestureDetector(
      onTap: () => expandControl(true),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("See More", style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
