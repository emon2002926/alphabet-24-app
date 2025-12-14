import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

class NewsCardWidget extends StatelessWidget {
  final bool isFullScreen;
  final String headline;
  final String category;
  final String imageUrl;
  final String description;
  final String time;

  const NewsCardWidget({
    super.key,
    required this.isFullScreen,
    required this.headline,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent, // transparent, inner container handle করবে
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.8, // <-- 80% of screen height
              child: Container(
                decoration: BoxDecoration(
                  color: SColor.bodyColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: DynamicSize.medium(context)),
                        Text(
                          headline,
                          style: STextTheme.headLine()
                              .copyWith(color: SColor.textPrimary, fontSize: 20),
                        ),
                        SizedBox(height: DynamicSize.small(context)),
                        Text(
                          time,
                          style: STextTheme.subHeadLine().copyWith(
                            fontSize: 12,
                            color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey,
                          ),
                        ),
                        SizedBox(height: DynamicSize.medium(context)),
                        Text(
                          description,
                          style: STextTheme.subHeadLine()
                              .copyWith(color: SColor.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );

      },
      child: Container(
        width: isFullScreen
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(DynamicSize.medium(context)),
        margin: isFullScreen
            ? EdgeInsets.only(bottom: DynamicSize.medium(context))
            : EdgeInsets.only(right: DynamicSize.medium(context)),
        decoration: BoxDecoration(
          color: SColor.bodyColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.20,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: DynamicSize.small(context)),
            Text(
              headline,
              style: STextTheme.headLine().copyWith(color: SColor.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: DynamicSize.small(context)),
            Text(
              description,
              style: STextTheme.subHeadLine().copyWith(color: SColor.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: DynamicSize.small(context)),
            Text(
              time,
              style: STextTheme.subHeadLine().copyWith(
                fontSize: 12,
                color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
