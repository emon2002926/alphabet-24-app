import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/universal_widgets/s_label.dart';
import '../../../core/universal_widgets/s_progress_widget.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../controllers/stats_controller.dart';

class StatsTabWidgets extends StatelessWidget {
  final int id;
  StatsTabWidgets({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatsController());
    controller.loadStats(id);

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      final data = controller.statsData.value;
      if (data == null) {
        return Center(child: Text("No data available"));
      }

      final topStats = data.predictions.correctScores.top10;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: DynamicSize.medium(context)),
          SLabel(title: 'Top Stats'),
          // Expanded for ListView
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: topStats.length,
              itemBuilder: (context, index) {
                final stat = topStats[index];
                return SProgressWidget(
                  label: stat.score,
                  value: stat.probability / 100,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
