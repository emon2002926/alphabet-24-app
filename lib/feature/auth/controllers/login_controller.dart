  import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
  import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
  import 'package:scaffassistant/core/helper/api_request/post_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/s_snackbar.dart';

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
          "remember_me": true
        },
      );
      postAPIRequest.sendData().then((response) {
        if (response.isNotEmpty) {
          final data = response['data'];
          final tokens = data != null ? data['tokens'] : null;
          final accessToken = tokens != null ? tokens['access'] : response['access_token'];
          if (accessToken != null && accessToken is String && accessToken.isNotEmpty) {
            print('Login successful. Access Token: $accessToken');
            UserInfo.setAccessToken(accessToken);
            UserStatus.setIsLoggedIn(true);
            Get.offAllNamed(RouteNames.initial);
            SSnackbar.success('Login successful');

            isLoading.value = false;
          } else {
            print('Login failed: access token missing in response');
            SSnackbar.error('Login failed: access token missing');

            isLoading.value = false;
          }
        } else {
          print('Login failed: Empty response');
          SSnackbar.error('Login failed: Empty response');

          isLoading.value = false;
        }
      }).catchError((error) {
        print('Login error: $error');
        SSnackbar.error('Login error');

        isLoading.value = false;
      });
    }
  }