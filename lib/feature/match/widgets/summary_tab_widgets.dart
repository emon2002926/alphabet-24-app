import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      final firstHalfScore =
          summaryData.summary.score.halftime?.display ?? '0-0';
      final secondHalfScore =
          summaryData.summary.score.current.display ?? '0-0';

      // Combine and sort events by minute
      final allFirstHalfEvents = [
        ...firstHalfHomeEvents,
        ...firstHalfAwayEvents
      ]..sort((a, b) => a.minute.compareTo(b.minute));

      final allSecondHalfEvents = [
        ...secondHalfHomeEvents,
        ...secondHalfAwayEvents
      ]..sort((a, b) => a.minute.compareTo(b.minute));

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DynamicSize.medium(context)),

            // 2nd Half (shown first, reverse order)
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xFF1E1E1E) : Color(0xFF1a1a2e),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '2ND-HALF',
                  style: STextTheme.headLine().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: DynamicSize.medium(context)),

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
              ...allSecondHalfEvents.reversed.map((event) {
                final isHomeTeam = event.team == 'home';
                return TimelineEventWidget(
                  event: event,
                  isHomeTeam: isHomeTeam,
                  isDark: isDark,
                );
              }),

            SizedBox(height: DynamicSize.large(context)),

            // 1st Half
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xFF1E1E1E) : Color(0xFF1a1a2e),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '1ST-HALF',
                  style: STextTheme.headLine().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: DynamicSize.medium(context)),

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
              ...allFirstHalfEvents.reversed.map((event) {
                final isHomeTeam = event.team == 'home';
                return TimelineEventWidget(
                  event: event,
                  isHomeTeam: isHomeTeam,
                  isDark: isDark,
                );
              }),

            SizedBox(height: DynamicSize.large(context)),

            // Prediction Section
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              child: Text(
                'PREDICTION',
                style: STextTheme.headLine().copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
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
                homeValue:
                '${summaryData.predictions.fulltimeResult.homeWin.toInt()}%',
                awayValue:
                '${summaryData.predictions.fulltimeResult.awayWin.toInt()}%',
                homePercentage: summaryData.predictions.fulltimeResult.homeWin,
                awayPercentage: summaryData.predictions.fulltimeResult.awayWin,
                isDark: isDark,
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),
          ],
        ),
      );
    });
  }
}

// Timeline Event Widget
class TimelineEventWidget extends StatelessWidget {
  final Event event;
  final bool isHomeTeam;
  final bool isDark;

  const TimelineEventWidget({
    super.key,
    required this.event,
    required this.isHomeTeam,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final playerName = event.player?.name ?? "Unknown";
    final extraMinute = event.extraMinute != null ? '+${event.extraMinute}' : '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(context),
        vertical: DynamicSize.small(context) * 0.3,
      ),
      child: Row(
        children: [
          // Left side (Home team)
          Expanded(
            child: isHomeTeam
                ? _buildEventContent(playerName, true)
                : SizedBox(),
          ),

          // Center timeline
          SizedBox(
            width: 80,
            child: Column(
              children: [
                // Timeline line
                Container(
                  width: 2,
                  height: 20,
                  color: isHomeTeam
                      ? (isDark ? Color(0xFF0ea5e9) : Color(0xFF0ea5e9))
                      : (isDark ? Color(0xFFec4899) : Color(0xFFec4899)),
                ),
                // Time badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isHomeTeam
                          ? (isDark ? Color(0xFF0ea5e9) : Color(0xFF0ea5e9))
                          : (isDark ? Color(0xFFec4899) : Color(0xFFec4899)),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                  ),
                  child: Text(
                    '${event.minute}\'$extraMinute',
                    style: STextTheme.headLine().copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isHomeTeam
                          ? (isDark ? Color(0xFF0ea5e9) : Color(0xFF0ea5e9))
                          : (isDark ? Color(0xFFec4899) : Color(0xFFec4899)),
                    ),
                  ),
                ),
                // Timeline line
                Container(
                  width: 2,
                  height: 20,
                  color: isHomeTeam
                      ? (isDark ? Color(0xFF0ea5e9) : Color(0xFF0ea5e9))
                      : (isDark ? Color(0xFFec4899) : Color(0xFFec4899)),
                ),
              ],
            ),
          ),

          // Right side (Away team)
          Expanded(
            child: !isHomeTeam
                ? _buildEventContent(playerName, false)
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventContent(String playerName, bool isLeft) {
    return Row(
      mainAxisAlignment:
      isLeft ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isLeft) SizedBox(width: 8),

        // Player image placeholder
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: _getEventIcon(event.type.code ?? ''),
        ),

        SizedBox(width: 8),

        Flexible(
          child: Column(
            crossAxisAlignment:
            isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLeft) _getEventTypeIcon(event.type.code ?? ''),
                  if (!isLeft) SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      playerName,
                      style: STextTheme.headLine().copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: isLeft ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                  if (isLeft) SizedBox(width: 4),
                  if (isLeft) _getEventTypeIcon(event.type.code ?? ''),
                ],
              ),
              SizedBox(height: 2),
              Text(
                event.type.name,
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 11,
                ),
                textAlign: isLeft ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),

        if (isLeft) SizedBox(width: 8),
      ],
    );
  }

  Widget _getEventIcon(String code) {
    IconData icon;

    switch (code) {
      case 'goal':
        icon = Icons.sports_soccer;
        break;
      case 'yellowcard':
        icon = Icons.square;
        break;
      case 'redcard':
        icon = Icons.square;
        break;
      case 'substitution':
        icon = Icons.swap_horiz;
        break;
      case 'var':
        icon = Icons.videocam;
        break;
      default:
        icon = Icons.person;
    }

    return Icon(
      icon,
      size: 16,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }

  Widget _getEventTypeIcon(String code) {
    IconData icon;
    Color? color;

    switch (code) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = Colors.green;
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

    return Icon(icon, size: 14, color: color);
  }
}