  import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
  import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
  import 'package:scaffassistant/core/helper/api_request/post_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/s_snackbar.dart';

import '../../../core/local_storage/user_status.dart';
import '../../../routing/route_name.dart';

  class SignupController extends GetxController{

    RxBool isLoading = false.obs;

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();

    void signUp() {
      isLoading.value = true;
      PostAPIRequest postAPIRequest = PostAPIRequest(
        url: APIEndpoint.signup,
        body: {
          "email": email.value.text,
          "password1": password.value.text,
          "password2": confirmPassword.value.text,
        },
      );
      postAPIRequest.sendData().then((response) {
        if (response.isNotEmpty) {
          final data = response['message'];
          SSnackbar.success(data ?? 'Signup successful');
          Get.toNamed(RouteNames.otpVerification, arguments: {
            'email': email.value.text,
            'isSignup': true,
          });
          isLoading.value = false;
        } else {
          SSnackbar.error('Signup failed');
          isLoading.value = false;
        }
      }).catchError((error) {
        SSnackbar.error('Error: $error');
        isLoading.value = false;
      });
    }

    void registerOTPVerification(String otp , String email) {
      isLoading.value = true;
      PostAPIRequest postAPIRequest = PostAPIRequest(
        url: APIEndpoint.verifyRegOTP,
        body: {
          "email": email,
          "otp": otp,
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