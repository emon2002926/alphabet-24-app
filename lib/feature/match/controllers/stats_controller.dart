import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/stats_model.dart';

class StatsController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var statsData = Rxn<StatsResponse>();
  var statsList = <StatData>[].obs;

  final Dio _dio = Dio();

  Future<void> loadStats(int fixtureId) async {
    try {
      isLoading(true);
      errorMessage('');

      final token = UserInfo.getAccessToken();

      final res = await _dio.get(
        "${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/statistics/",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      statsData.value = StatsResponse.fromJson(res.data);
      _buildStatsList();
    } catch (e) {
      errorMessage("Failed to load stats: $e");
      print("Error loading stats: $e");
    } finally {
      isLoading(false);
    }
  }

  void _buildStatsList() {
    final data = statsData.value;
    if (data == null) return;

    final comparison = data.data.comparison;
    final homeTeam = data.data.homeTeam;
    final awayTeam = data.data.awayTeam;

    statsList.clear();

    // Expected Goals
    if (homeTeam.statistics.containsKey('expected-goals')) {
      final homeValue = homeTeam.statistics['expected-goals']!.value;
      final awayValue = awayTeam.statistics['expected-goals']!.value;
      final total = (homeValue as num).toDouble() + (awayValue as num).toDouble();

      statsList.add(StatData(
        name: 'Expected Goals (xG)',
        homeValue: homeValue.toString(),
        awayValue: awayValue.toString(),
        homePercentage: total > 0 ? ((homeValue as num).toDouble() / total * 100) : 50,
        awayPercentage: total > 0 ? ((awayValue as num).toDouble() / total * 100) : 50,
      ));
    }

    // Ball Possession
    if (comparison.containsKey('ball-possession')) {
      final stat = comparison['ball-possession']!;
      statsList.add(StatData(
        name: stat.name,
        homeValue: '${stat.homeValue.toInt()}%',
        awayValue: '${stat.awayValue.toInt()}%',
        homePercentage: stat.homePercentage,
        awayPercentage: stat.awayPercentage,
      ));
    }

    // Total Shots
    if (comparison.containsKey('shots-total')) {
      final stat = comparison['shots-total']!;
      statsList.add(StatData(
        name: 'Total shots',
        homeValue: stat.homeValue.toInt().toString(),
        awayValue: stat.awayValue.toInt().toString(),
        homePercentage: stat.homePercentage,
        awayPercentage: stat.awayPercentage,
      ));
    }

    // Shots on Target
    if (comparison.containsKey('shots-on-target')) {
      final stat = comparison['shots-on-target']!;
      statsList.add(StatData(
        name: 'Shots on target',
        homeValue: stat.homeValue.toInt().toString(),
        awayValue: stat.awayValue.toInt().toString(),
        homePercentage: stat.homePercentage,
        awayPercentage: stat.awayPercentage,
      ));
    }

    // Big Chances
    if (homeTeam.statistics.containsKey('big-chances-created')) {
      final homeValue = homeTeam.statistics['big-chances-created']!.value;
      final awayValue = awayTeam.statistics['big-chances-created']!.value;
      final total = (homeValue as num).toDouble() + (awayValue as num).toDouble();

      statsList.add(StatData(
        name: 'Big chances',
        homeValue: homeValue.toString(),
        awayValue: awayValue.toString(),
        homePercentage: total > 0 ? ((homeValue as num).toDouble() / total * 100) : 50,
        awayPercentage: total > 0 ? ((awayValue as num).toDouble() / total * 100) : 50,
      ));
    }

    // Corners
    if (comparison.containsKey('corners')) {
      final stat = comparison['corners']!;
      statsList.add(StatData(
        name: 'Corner kicks',
        homeValue: stat.homeValue.toInt().toString(),
        awayValue: stat.awayValue.toInt().toString(),
        homePercentage: stat.homePercentage,
        awayPercentage: stat.awayPercentage,
      ));
    }

    // Passes
    if (homeTeam.statistics.containsKey('successful-passes-percentage')) {
      final homeValue = homeTeam.statistics['successful-passes-percentage']!.value;
      final awayValue = awayTeam.statistics['successful-passes-percentage']!.value;

      statsList.add(StatData(
        name: 'Passes',
        homeValue: '${homeValue}%',
        awayValue: '${awayValue}%',
        homePercentage: (homeValue as num).toDouble(),
        awayPercentage: (awayValue as num).toDouble(),
      ));
    }

    // Yellow Cards
    if (homeTeam.statistics.containsKey('yellowcards')) {
      final homeValue = homeTeam.statistics['yellowcards']!.value;
      final awayValue = awayTeam.statistics['yellowcards']!.value;
      final total = (homeValue as num).toDouble() + (awayValue as num).toDouble();

      statsList.add(StatData(
        name: 'Yellow Cards',
        homeValue: homeValue.toString(),
        awayValue: awayValue.toString(),
        homePercentage: total > 0 ? ((homeValue as num).toDouble() / total * 100) : 50,
        awayPercentage: total > 0 ? ((awayValue as num).toDouble() / total * 100) : 50,
      ));
    }
  }
}

// StatData model class
class StatData {
  final String name;
  final String homeValue;
  final String awayValue;
  final double homePercentage;
  final double awayPercentage;

  StatData({
    required this.name,
    required this.homeValue,
    required this.awayValue,
    required this.homePercentage,
    required this.awayPercentage,
  });
}