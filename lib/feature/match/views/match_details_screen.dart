import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/universal_widgets/s_label.dart';
import '../widgets/h2h_tabWidget.dart';
import '../widgets/lineup_tab_widget.dart';
import '../widgets/match_header.dart';
import '../widgets/stats_tab_widgets.dart';
import '../widgets/summary_tab_widgets.dart';
import '../../../core/const/string_const/icon_path.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';

class MatchDetailsScreen extends StatelessWidget {
  const MatchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments['matchId'];
    print('Match ID: $id');

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 270),
        child: MatchHeader(matchId: id.toString()),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: SColor.primary,
              indicatorColor: SColor.primary,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
              labelStyle: STextTheme.headLine().copyWith(fontSize: 12),
              tabs: const [
                Tab(text: 'SUMMARY'),
                Tab(text: 'LINEUP'),
                Tab(text: 'H2H'),
                Tab(text: 'STATS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const SummaryTabWidgets(),
                  LineUp(
                    fixtureId: id,
                  ), // dynamically pass data if required
                  H2H(
                    fixtureId: id,
                  ),
                  StatsTabWidgets(
                    id: id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




