import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../models/news_list_model.dart';

class NewsListController extends GetxController {
  RxList<NewsItem> newsList = <NewsItem>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(APIEndpoint.newsList),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
        },
      );

      print('GET → ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['news'] ?? [];

        newsList.value =
            list.map<NewsItem>((item) => NewsItem.fromJson(item)).toList();
      } else {
        print("Server Error Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news → $e");
    } finally {
      isLoading.value = false;
    }
  }
}
