import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scaffassistant/core/universal_widgets/custom_alart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../core/universal_widgets/custom_snackbar.dart';
import '../../../routing/route_name.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxBool isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool("isDarkMode") ?? false;

    // Set initial theme
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", value);

    // Apply theme instantly everywhere
    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void deleteAccount() {
    CustomAlertDialog.show(
      Get.context!,
      title: "Delete Account",
      message: "Are you sure you want to delete your account? This action is permanent and cannot be undone. All your data will be lost forever.",
      confirmText: "Delete Account",
      cancelText: "Keep Account",
      type: AlertType.error,
      onConfirm: () async {
        await _performDeleteAccount();
      },
      onCancel: () {
        // User cancelled
      },
    );
  }

  Future<void> _performDeleteAccount() async {
    try {
      isDeleting.value = true;

      final token = UserInfo.getAccessToken();

      if (token == null || token.isEmpty) {
        CustomSnackbar.error('No access token found');
        isDeleting.value = false;
        return;
      }

      // Make DELETE request
      final response = await http.delete(
        Uri.parse('${APIEndpoint.baseURL}authentication/delete-account/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'delete': true,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Clear user data
        UserInfo.clearUserInfo();

        // Show success dialog
        await CustomAlertDialog.success(
          Get.context!,
          title: "Account Deleted",
          message: jsonResponse['message'] ?? "Your account has been deleted successfully.",
          confirmText: "OK",
          onConfirm: () {
            // Navigate to login
            Get.offAllNamed(RouteNames.login);
          },
        );

        // If user dismisses the dialog, still navigate
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed(RouteNames.login);
        });

      } else if (response.statusCode == 401) {
        CustomSnackbar.error('Unauthorized: Invalid or expired token');

        // Clear invalid token and redirect to login
        UserInfo.clearUserInfo();
        Get.offAllNamed(RouteNames.login);

      } else if (response.statusCode == 400) {
        try {
          final jsonResponse = json.decode(response.body);
          CustomSnackbar.error(
            jsonResponse['message'] ?? 'Bad request',
          );
        } catch (e) {
          CustomSnackbar.error('Failed to delete account');
        }
      } else {
        try {
          final jsonResponse = json.decode(response.body);
          CustomSnackbar.error(
            jsonResponse['message'] ?? 'Failed to delete account',
          );
        } catch (e) {
          CustomSnackbar.error(
            'Failed to delete account: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      CustomSnackbar.error('An error occurred: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  void logOut() {
    CustomAlertDialog.confirm(
      Get.context!,
      title: "Logout",
      message: "Are you sure you want to logout from your account?",
      confirmText: "Logout",
      cancelText: "Cancel",
      onConfirm: () {
        // Clear user data and navigate to login
        UserInfo.clearUserInfo();
        Get.offAllNamed(RouteNames.login);

        // Show success message
        Future.delayed(const Duration(milliseconds: 300), () {
          CustomSnackbar.success('Logged out successfully');
        });
      },
      onCancel: () {
        // User cancelled logout
      },
    );
  }
}