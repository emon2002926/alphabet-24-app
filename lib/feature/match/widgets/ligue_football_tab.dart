import 'package:flutter/material.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/s_text_field.dart';


class LigueFootballTab extends StatefulWidget {
  const LigueFootballTab({super.key});

  @override
  State<LigueFootballTab> createState() => _LigueFootballTabState();
}

class _LigueFootballTabState extends State<LigueFootballTab> {


  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> leagues = [
      {'name': 'Premier League', 'logo': 'assets/images/UEL.png', 'count': 28},
      {'name': 'La Liga', 'logo': 'assets/images/UEL.png', 'count': 24},
      {'name': 'Serie A', 'logo': 'assets/images/UEL.png', 'count': 21},
      {'name': 'Bundesliga', 'logo': 'assets/images/UEL.png', 'count': 19},
      {'name': 'Ligue 1', 'logo': 'assets/images/UEL.png', 'count': 16},
    ];

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: STextField(
                    hintText: 'Search League',
                    labelText: 'Search Your match',
                    suffixIcon: Icon(Icons.search, color: SColor.primary,)
                ),
              ),
            ),

            label(context),
            // LeagueListWidget(leagues: leagues)

          ],
        )
      ),
    );
  }

  Container label(BuildContext context) {
    return Container(
            width: double.infinity,
            color: Color(0xFFE5E5E5),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DynamicSize.medium(context),
                vertical: DynamicSize.small(context)*0.6,
              ),
              child: Text(
                'FAVOURITE COMPETITION',
                style: STextTheme.headLineBold().copyWith(
                  fontSize: 12,
                ),
              ),
            ),
          );
  }


}




