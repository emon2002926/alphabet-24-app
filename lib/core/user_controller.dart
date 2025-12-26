import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/feature/settings/models/account_model.dart';
import 'dart:convert';
import 'const/string_const/API_endpoint.dart';


class UserController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<AccountModel?> userProfile = Rx<AccountModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'No access token found',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(APIEndpoint.userInfo),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Extract data from the response structure
        if (jsonResponse['data'] != null) {
          userProfile.value = AccountModel.fromJson(jsonResponse['data']);
          print(userProfile.value?.fullName);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Error',
          'Unauthorized: Invalid or expired token',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load profile: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to refresh profile data
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }
}