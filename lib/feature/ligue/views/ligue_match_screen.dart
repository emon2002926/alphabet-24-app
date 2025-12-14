import 'package:flutter/material.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import 'package:scaffassistant/feature/prediction/widgets/predicted_football_tab.dart';

import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../home/widgets/football_screen.dart';
import '../widgets/ligue_football_tab.dart';

class LigueMatchScreen extends StatelessWidget {
  const LigueMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'All Ligue'),
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
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      height: 100,
                      color: Color(0xFFE41833),
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/UEL.png'), height: 10,),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Football Matches', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              SizedBox(height: 5,),
                              Text('Explore various football leagues and matches.', style: TextStyle(fontSize: 14),),
                            ],
                          )
                        ],
                      ),
                    )
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
