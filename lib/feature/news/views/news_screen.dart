import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import '../../../feature/home/controllers/sports_data/football_data/news_list_controller.dart';
import '../../../core/universal_widgets/news_card_widget.dart';

class NewsScreen extends StatelessWidget {
  final NewsListController newsListController = Get.put(NewsListController());

  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SAppBar(title: 'News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (newsListController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (newsListController.newsList.isEmpty) {
            return const Center(
              child: Text('No news available'),
            );
          } else {
            return ListView.separated(
              itemCount: newsListController.newsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final news = newsListController.newsList[index];
                return NewsCardWidget(
                  isFullScreen: true,
                  headline: news.title,
                  category: news.type,
                  imageUrl: news.league.logo,
                  time: news.matchDate.toString(),
                  description: news.lines.isNotEmpty
                      ? news.lines.map((line) => line.text).join('\n\n')
                      : '',
                );
              },
            );
          }
        }),
      ),
    );
  }
}
