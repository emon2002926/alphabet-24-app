import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/universal_widgets/s_progress_widget.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../controllers/stats_controller.dart';

class StatsTabWidgets extends StatelessWidget {
  final int id;
  const StatsTabWidgets({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatsController());
    controller.loadStats(id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      if (controller.statsList.isEmpty) {
        return Center(
          child: Text(
            "No data available",
            style: STextTheme.subHeadLine(),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: DynamicSize.medium(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Top Stats',
              style: STextTheme.headLineBold(),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: controller.statsList.length,
              itemBuilder: (context, index) {
                final stat = controller.statsList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: SProgressWidget(
                    label: stat.name,
                    homeValue: stat.homeValue,
                    awayValue: stat.awayValue,
                    homePercentage: stat.homePercentage,
                    awayPercentage: stat.awayPercentage,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}