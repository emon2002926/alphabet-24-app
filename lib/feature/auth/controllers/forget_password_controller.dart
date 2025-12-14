import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/feature/auth/screens/password_change_screen.dart';
import 'package:scaffassistant/feature/auth/screens/update_password.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/universal_widgets/s_snackbar.dart';
import '../../../routing/route_name.dart';


class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> sendOTP(String email) async {
    isLoading.value = true;
    try{
      final response = await http.post(
        Uri.parse('${APIEndpoint.baseURL}authentication/send-passwordreset-otp/'),
        body: {
          'email': email,
        },
      );
      print('Response status for forget password: ${response.statusCode} and body: ${response.body}');
      if (response.statusCode == 200) {
        SSnackbar.success("OTP sent successfully to your email");
        Get.toNamed(RouteNames.otpVerification, arguments: {
          'email': email,
          'isSignup': false,

        });
        isLoading.value = false;
      }else{
        SSnackbar.error("Failed to send OTP");
        isLoading.value = false;
      }
    }catch(e){
      SSnackbar.error("An error occurred: $e");
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    isLoading.value = true;
    try{
      final response = await http.post(
        Uri.parse('${APIEndpoint.baseURL}authentication/verify-passwordreset-otp/'),
        body: {
          'email': email,
          'otp': otp,
        },
      );

      print('Response status for verify OTP: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {

        final result = jsonDecode(response.body);
        final token = result['data']['token'];


        SSnackbar.success("OTP verified successfully");
        Get.to(
          UpdatePassword(token: token)
        );
        isLoading.value = false;
      }else{
        SSnackbar.error("Failed to verify OTP");
        isLoading.value = false;
      }
    }catch(e){
      SSnackbar.error("An error occurred: $e");
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String token, String password, String confirmPassword) async {
    isLoading.value = true;
    try{
      final response = await http.post(
        Uri.parse('${APIEndpoint.baseURL}authentication/set-password/'),
        body: {
          'token': token,
          'password1': password,
          'password2': confirmPassword,
        },
      );

      print('Response status for reset password: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        SSnackbar.success("Password reset successfully");
        Get.offAllNamed(RouteNames.login);
        isLoading.value = false;
      }else{
        SSnackbar.error("Failed to reset password");
        isLoading.value = false;
      }
    }catch(e){
      SSnackbar.error("An error occurred: $e");
      isLoading.value = false;
    }
  }

}