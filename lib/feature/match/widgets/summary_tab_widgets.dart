import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/universal_widgets/s_label.dart';
import 'package:scaffassistant/feature/match/controllers/summary_controller.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/universal_widgets/s_progress_widget.dart';
import '../models/summary_model.dart';

class SummaryTabWidgets extends StatelessWidget {
  final int id;
  const SummaryTabWidgets({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final summaryController = Get.put(SummaryController());
    summaryController.fetchSummary(id.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (summaryController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      }

      final summaryData = summaryController.summaryData.value;
      if (summaryData == null) {
        return Center(
          child: Text(
            "No data available",
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      // Split home and away events by half
      final firstHalfHomeEvents = summaryData.summary.homeTeam.events
          .where((e) => e.minute <= 45)
          .toList();
      final secondHalfHomeEvents = summaryData.summary.homeTeam.events
          .where((e) => e.minute > 45)
          .toList();

      final firstHalfAwayEvents = summaryData.summary.awayTeam.events
          .where((e) => e.minute <= 45)
          .toList();
      final secondHalfAwayEvents = summaryData.summary.awayTeam.events
          .where((e) => e.minute > 45)
          .toList();

      // Get halftime and fulltime scores
      final firstHalfScore = summaryData.summary.score.halftime?.display ?? '0-0';
      final secondHalfScore = summaryData.summary.score.current.display ?? '0-0';
      final predictionScore = summaryData.summary.score.current.display ?? '0-0';

      // Combine and sort events by minute
      final allFirstHalfEvents = [...firstHalfHomeEvents, ...firstHalfAwayEvents]
        ..sort((a, b) => a.minute.compareTo(b.minute));

      final allSecondHalfEvents = [...secondHalfHomeEvents, ...secondHalfAwayEvents]
        ..sort((a, b) => a.minute.compareTo(b.minute));

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // 1st Half
            SLabel(title: '1st Half', score: firstHalfScore),
            if (allFirstHalfEvents.isEmpty)
              Padding(
                padding: EdgeInsets.all(DynamicSize.medium(context)),
                child: Center(
                  child: Text(
                    'No events in first half',
                    style: STextTheme.subHeadLine(),
                  ),
                ),
              )
            else
              ...allFirstHalfEvents.map((event) {
                final isHomeTeam = event.team == 'home';
                return isHomeTeam
                    ? RightAlignSectionWidget(event, isDark)
                    : LeftAlignSectionWidget(event, isDark);
              }),

            SizedBox(height: DynamicSize.medium(context)),

            // 2nd Half
            SLabel(title: '2nd Half', score: secondHalfScore),
            if (allSecondHalfEvents.isEmpty)
              Padding(
                padding: EdgeInsets.all(DynamicSize.medium(context)),
                child: Center(
                  child: Text(
                    'No events in second half',
                    style: STextTheme.subHeadLine(),
                  ),
                ),
              )
            else
              ...allSecondHalfEvents.map((event) {
                final isHomeTeam = event.team == 'home';
                return isHomeTeam
                    ? RightAlignSectionWidget(event, isDark)
                    : LeftAlignSectionWidget(event, isDark);
              }),

            SizedBox(height: DynamicSize.medium(context)),

            // Prediction Section
            SLabel(title: 'Prediction', score: predictionScore),
            SizedBox(height: DynamicSize.small(context)),

            // Expected Goals
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DynamicSize.medium(context),
                vertical: DynamicSize.small(context),
              ),
              child: SProgressWidget(
                label: 'Expected Goals (xG)',
                homeValue: '0.34',
                awayValue: '0.34',
                homePercentage: 50,
                awayPercentage: 50,
                isDark: isDark,
              ),
            ),

            // Winning Possibility
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DynamicSize.medium(context),
                vertical: DynamicSize.small(context),
              ),
              child: SProgressWidget(
                label: 'Winning Possibility',
                homeValue: '${summaryData.predictions.fulltimeResult.homeWin.toInt()}%',
                awayValue: '${summaryData.predictions.fulltimeResult.awayWin.toInt()}%',
                homePercentage: summaryData.predictions.fulltimeResult.homeWin,
                awayPercentage: summaryData.predictions.fulltimeResult.awayWin,
                isDark: isDark,
              ),
            ),

            SizedBox(height: DynamicSize.medium(context)),
          ],
        ),
      );
    });
  }

  // Right-aligned events for Home team
  Widget RightAlignSectionWidget(Event event, bool isDark) {
    final playerName = event.player?.name ?? "Unknown";
    final extraMinute = event.extraMinute != null ? '+${event.extraMinute}' : '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(Get.context!),
        vertical: DynamicSize.small(Get.context!) * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              '($playerName) ',
              style: STextTheme.subHeadLine().copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            event.type.name,
            style: STextTheme.headLine().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2C2C2C) : Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${event.minute}\'$extraMinute',
              style: STextTheme.headLine().copyWith(fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          _getEventIcon(event.type.code ?? '', isDark),
        ],
      ),
    );
  }

  // Left-aligned events for Away team
  Widget LeftAlignSectionWidget(Event event, bool isDark) {
    final playerName = event.player?.name ?? "Unknown";
    final extraMinute = event.extraMinute != null ? '+${event.extraMinute}' : '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(Get.context!),
        vertical: DynamicSize.small(Get.context!) * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getEventIcon(event.type.code ?? '', isDark),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2C2C2C) : Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${event.minute}\'$extraMinute',
              style: STextTheme.headLine().copyWith(fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          Text(
            event.type.name,
            style: STextTheme.headLine().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              '($playerName)',
              style: STextTheme.subHeadLine().copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEventIcon(String code, bool isDark) {
    IconData icon;
    Color? color;

    switch (code) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = Colors.black;
        break;
      case 'yellowcard':
        icon = Icons.square;
        color = Colors.yellow[700];
        break;
      case 'redcard':
        icon = Icons.square;
        color = Colors.red;
        break;
      case 'substitution':
        icon = Icons.swap_horiz;
        color = isDark ? Colors.white70 : Colors.black87;
        break;
      case 'var':
        icon = Icons.videocam;
        color = isDark ? Colors.white70 : Colors.black87;
        break;
      default:
        icon = Icons.sports_soccer;
        color = isDark ? Colors.white70 : Colors.black87;
    }

    return Icon(icon, size: 20, color: color);
  }
}