import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/universal_widgets/s_label.dart';
import 'package:scaffassistant/feature/match/controllers/summary_controller.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/universal_widgets/s_progress_widget.dart';

class SummaryTabWidgets extends StatelessWidget {
  const SummaryTabWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final summaryController = Get.find<SummaryController>();

    return Obx(() {
      final summaryData = summaryController.summaryData.value;
      if (summaryData == null) {
        return const Center(child: CircularProgressIndicator());
      }

      // Split home and away events by half
      final firstHalfHomeEvents =
      summaryData.summary.homeTeam.events.where((e) => e.minute <= 45).toList();
      final secondHalfHomeEvents =
      summaryData.summary.homeTeam.events.where((e) => e.minute > 45).toList();

      final firstHalfAwayEvents =
      summaryData.summary.awayTeam.events.where((e) => e.minute <= 45).toList();
      final secondHalfAwayEvents =
      summaryData.summary.awayTeam.events.where((e) => e.minute > 45).toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // 1st Half
            SLabel(
              title: '1st Half',
              score: summaryData.summary.score.current.display ?? '0 - 0',
            ),
            ...firstHalfHomeEvents.map((e) => RightAlignSectionWidget(e)),
            ...firstHalfAwayEvents.map((e) => LeftAlignSectionWidget(e)),

            SizedBox(height: DynamicSize.medium(context)),

            // 2nd Half
            SLabel(
              title: '2nd Half',
              score: summaryData.summary.score.current.display ?? '0 - 0',
            ),
            ...secondHalfHomeEvents.map((e) => RightAlignSectionWidget(e)),
            ...secondHalfAwayEvents.map((e) => LeftAlignSectionWidget(e)),

            SizedBox(height: DynamicSize.medium(context)),

            // Prediction Section
            SLabel(
              title: 'Prediction',
              score: summaryData.summary.score.current.display ?? '0 - 0',
            ),
            ...summaryData.predictions.correctScores.top5.map((p) => SProgressWidget(
              label: p.score,
              value: p.probability / 100,
            )),
          ],
        ),
      );
    });
  }

  // Right-aligned events for Home team
  Padding RightAlignSectionWidget(event) {
    final playerName = event.player?.name ?? "Unknown"; // <-- null-safe

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(Get.context!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('($playerName) ', style: STextTheme.subHeadLine().copyWith(fontSize: 14)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(event.type.name, style: STextTheme.headLine().copyWith(fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text('${event.minute}’', style: STextTheme.headLine().copyWith(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Image.asset(IconPath.football, height: 20, width: 20, color: Colors.black),
        ],
      ),
    );
  }

  // Left-aligned events for Away team
  Padding LeftAlignSectionWidget(event) {
    final playerName = event.player?.name ?? "Unknown"; // <-- null-safe

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(Get.context!),
        vertical: DynamicSize.small(Get.context!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text('${event.minute}’', style: STextTheme.headLine().copyWith(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Image.asset(IconPath.swap, height: 20, width: 20),
          const SizedBox(width: 4),
          Text(event.type.name, style: STextTheme.headLine().copyWith(fontSize: 14)),
          const SizedBox(width: 4),
          Text('($playerName)', style: STextTheme.subHeadLine().copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
