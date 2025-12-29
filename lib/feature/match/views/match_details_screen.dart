import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/universal_widgets/s_label.dart';
import '../widgets/h2h_tabWidget.dart';
import '../widgets/lineup_tab_widget.dart';
import '../widgets/match_header.dart';
import '../widgets/predictions_tab_widgets.dart';
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
      body: SafeArea(
        child: DefaultTabController(
          length: 5, // Changed from 4 to 5
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 300,
                  floating: false,
                  pinned: false,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: MatchHeader(matchId: id.toString()),
                    ),
                    collapseMode: CollapseMode.parallax,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                ),
                // Pinned TabBar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      isScrollable: true, // Added to handle 5 tabs nicely
                      labelColor: SColor.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: SColor.primary,
                      indicatorWeight: 3,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: STextTheme.headLine().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: const [
                        Tab(text: 'SUMMARY'),
                        Tab(text: 'LINEUP'),
                        Tab(text: 'H2H'),
                        Tab(text: 'STATS'),
                        Tab(text: 'PREDICTION'), // Add your new tab name here
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                SummaryTabWidgets(id: id),
                LineUp(fixtureId: id),
                H2H(fixtureId: id),
                StatsTabWidgets(id: id),
                PredictionsTabWidgets(id: id), // Add your new tab widget here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom delegate for pinned TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 16;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: SColor.bodyColor,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}