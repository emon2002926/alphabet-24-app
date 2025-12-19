import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../core/universal_widgets/s_snackbar.dart';
import '../../home/models/live_match_response_model.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavouriteController extends GetxController {
  RxList<FavouriteFixture> favouriteFixtures = <FavouriteFixture>[].obs;
  RxList<dynamic> favouriteTeams = <dynamic>[].obs;
  RxList<FavouriteLeague> favouriteLeagues = <FavouriteLeague>[].obs;
  RxInt totalFavourites = 0.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavourites();
  }

  // Filtered fixtures based on search
  List<FavouriteFixture> get filteredFixtures {
    if (searchQuery.value.isEmpty) {
      return favouriteFixtures;
    }
    return favouriteFixtures.where((fixture) {
      return fixture.homeTeam.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          fixture.awayTeam.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  // Filtered leagues based on search
  List<FavouriteLeague> get filteredLeagues {
    if (searchQuery.value.isEmpty) {
      return favouriteLeagues;
    }
    return favouriteLeagues.where((league) {
      return league.leagueName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          league.leagueCountry.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  Future<void> fetchFavourites() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
      );

      print('Favourite API Response: ${response.statusCode}');
      print('Favourite API Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final favouriteResponse = FavouriteResponse.fromJson(data);
          favouriteFixtures.value = favouriteResponse.fixtures;
          favouriteTeams.value = favouriteResponse.teams;
          favouriteLeagues.value = favouriteResponse.leagues;
          totalFavourites.value = favouriteResponse.total;

          print('Favourite Fixtures Loaded: ${favouriteFixtures.length}');
          print('Favourite Leagues Loaded: ${favouriteLeagues.length}');
        }
      } else {
        print('Failed to fetch favourites: ${response.statusCode}');
        SSnackbar.error('Failed to load favourites');
      }
    } catch (e) {
      print('Error fetching favourites: $e');
      SSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFixtureFavourite(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${APIEndpoint.userFavorites}'),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        favouriteFixtures.removeWhere((f) => f.id == id);
        totalFavourites.value = favouriteFixtures.length + favouriteLeagues.length;
        SSnackbar.success('Match removed from favourites');
      } else {
        SSnackbar.error('Failed to remove favourite');
      }
    } catch (e) {
      print('Error removing favourite: $e');
      SSnackbar.error('Something went wrong');
    }
  }

  Future<void> removeLeagueFavourite(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${APIEndpoint.userFavorites}$id/'),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        favouriteLeagues.removeWhere((l) => l.id == id);
        totalFavourites.value = favouriteFixtures.length + favouriteLeagues.length;
        SSnackbar.success('League removed from favourites');
      } else {
        SSnackbar.error('Failed to remove favourite');
      }
    } catch (e) {
      print('Error removing favourite: $e');
      SSnackbar.error('Something went wrong');
    }
  }
}