import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import '../../../models/basketball_leagues_model.dart';

class BasketballLeaguesController extends GetxController {
  var basketballLeagues = <BasketballLeague>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final String apiUrl = '${APIEndpoint.baseURL}basketball-data/leagues/';

  @override
  void onInit() {
    super.onInit();
    fetchLeagues();
  }

  Future<void> fetchLeagues() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(Uri.parse(apiUrl));
      print('Response status for basketball: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final leagues = jsonData['leagues'] as List<dynamic>;

basketballLeagues.assignAll(
  leagues.map((leagueJson) => BasketballLeague.fromJson(leagueJson as Map<String, dynamic>)).toList(),
);
      } else {
        errorMessage.value = 'Failed to load leagues: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
