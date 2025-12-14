import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  RxBool isDarkMode = false.obs;

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
}
