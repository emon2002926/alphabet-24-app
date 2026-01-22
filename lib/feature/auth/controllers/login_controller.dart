  import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
  import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
  import 'package:scaffassistant/core/helper/api_request/post_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/custom_snackbar.dart';

import '../../../core/local_storage/user_status.dart';
import '../../../routing/route_name.dart';

  class LoginController extends GetxController{

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    RxBool isLoading = false.obs;

    void login() {
      isLoading.value = true;

      PostAPIRequest postAPIRequest = PostAPIRequest(
        url: APIEndpoint.login,
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "remember_me": true,
        },
      );

      postAPIRequest.sendData().then((result) {
        isLoading.value = false;

        final int statusCode = result['statusCode'];
        final Map<String, dynamic> response = result['data'];

        if (statusCode == 200) {
          // Extract tokens
          final data = response['data'];
          final tokens = data?['tokens'];
          final accessToken = tokens?['access'];
          final refreshToken = tokens?['refresh'];

          if (accessToken != null && accessToken.isNotEmpty) {
            // ✅ Save tokens
            UserInfo.setAccessToken(accessToken);
            // UserInfo.setRefreshToken(refreshToken ?? '');
            UserStatus.setIsLoggedIn(true);

            // Optional: save user info
            final user = data?['user'];
            // if (user != null) {
            //   UserInfo.setUser(user); // Implement this method in your UserInfo
            // }

            Get.offAllNamed(RouteNames.initial);
            CustomSnackbar.success(response['message'] ?? 'Login successful');
          } else {
            CustomSnackbar.error('Invalid token received');
          }
        } else {
          // Show actual server error
          CustomSnackbar.error(
            response['error'] ??
                response['message'] ??
                'Incorrect email or password',
          );
        }
      }).catchError((e) {
        isLoading.value = false;

        if (e is DioException && e.response?.data != null) {
          final errorMsg = e.response?.data['error'] ??
              e.response?.data['message'] ??
              'Server error. Please try again.';
          CustomSnackbar.error(errorMsg);
        } else {
          CustomSnackbar.error('Network error. Please try again.');
        }

        print('Login exception: $e');
      });
    }
  }