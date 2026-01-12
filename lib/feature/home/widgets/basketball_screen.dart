import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/basketball/basketball_league_list_widget.dart';
import 'package:scaffassistant/core/universal_widgets/scoure_card_widget.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/basketball/basketball_leagues_controller.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/football_live_match_controller.dart';
import 'package:scaffassistant/feature/home/controllers/sports_data/football_data/news_list_controller.dart';
import 'package:scaffassistant/feature/ligue/views/basketball/basketball_ligue_list_screen.dart';
import 'package:scaffassistant/feature/news/views/news_screen.dart';
import '../../../core/universal_widgets/news_card_widget.dart';

class BasketballScreen extends StatefulWidget {
  const BasketballScreen({super.key});

  @override
  State<BasketballScreen> createState() => _BasketballScreenState();
}

class _BasketballScreenState extends State<BasketballScreen> {
  final FootballLiveMatchController liveMatchController =
  Get.put(FootballLiveMatchController());
  final NewsListController newsListController = Get.put(NewsListController());

  final BasketballLeaguesController basketballLeaguesController = Get.put(BasketballLeaguesController());

  @override
  Widget build(BuildContext context) {
    final bool isNew = true;

    return Container(
      color: SColor.bodyColor,
      padding: EdgeInsets.all(DynamicSize.small(context)),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Now
            Obx(() {
              if (liveMatchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (liveMatchController.liveMatches.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelWidget('Live Now', false),
                    SizedBox(height: DynamicSize.small(context)),
                    _ScoureCard(context, isNew),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            SizedBox(height: DynamicSize.medium(context)),

            // Leagues
            Obx(() {
              if (basketballLeaguesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (basketballLeaguesController.basketballLeagues.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelWidget('Leagues', true),
                    SizedBox(height: DynamicSize.small(context)),
                    BasketballLeagueListWidget(
                      controller: basketballLeaguesController,
                      showDivider: true,
                      itemCount: 5,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            SizedBox(height: DynamicSize.medium(context)),

            // Top Stories
            Obx(() {
              if (newsListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (newsListController.newsList.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelWidget('Top Stories', true),
                    SizedBox(height: DynamicSize.small(context)),
                    _NewsCard(context),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  // Horizontal scroll for live matches
  SizedBox _ScoureCard(BuildContext context, bool isNew) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,

      child: Obx(() {   // <-- MUST wrap with Obx
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 12),

          itemCount: liveMatchController.liveMatches.length,

          itemBuilder: (context, index) {
            return ScoureCardWidget(
              index: index,
            );
          },
        );
      }),
    );
  }


  // Horizontal scroll for news
  SizedBox _NewsCard(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 5,
        itemBuilder: (context, index) {
          final news = newsListController.newsList[index];
          return NewsCardWidget(
            isFullScreen: false,
            headline: news.title,
            category: news.type,
            imageUrl: news.league.logo,
            time: news.matchDate.toString(),
            description: news.lines.isNotEmpty
                ? news.lines.map((line) => line.text).join('\n\n')
                : '',
          );
        },
      ),
    );
  }



  Row LabelWidget(String title , bool isSeeAllVisible) {
    return Row(
      children: [
        Text(title, style: STextTheme.headLineBold()),
        const Spacer(),
        isSeeAllVisible ? GestureDetector(
          onTap: () {
            if(title == 'Leagues'){
              Get.to(
                BasketballLigueListScreen(
                  controller: basketballLeaguesController,
                  showDivider: true,
                ),
              );
            }else if(title == 'Top Stories'){
              Get.to(
                NewsScreen(
                ),
              );
            }
          },
          child: Row(
            children: [
              Text(
                'See All',
                style: STextTheme.subHeadLine().copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
            ],
          ),
        ) : const SizedBox.shrink(),
      ],
    );
  }
}
