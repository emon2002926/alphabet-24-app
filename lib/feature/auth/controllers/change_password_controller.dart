import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/custom_snackbar.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> changePassword(String oldPassword, String newPassword, String confirmNewPassword) async {
    isLoading.value = true;

    try {
      final accessToken = UserInfo.getAccessToken();
      final response = await http.post(
        Uri.parse('${APIEndpoint.baseURL}authentication/change-password/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmNewPassword,
        },
      );

      print('Response status for change password: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        CustomSnackbar.success("Password changed successfully");
        Get.back();
      } else {
        CustomSnackbar.error("Failed to change password");
      }

    } catch (e) {
      CustomSnackbar.error("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

}