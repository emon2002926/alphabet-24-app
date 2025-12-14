import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scaffassistant/core/local_storage/user_status.dart';
import 'package:scaffassistant/routing/route_name.dart';
import 'package:scaffassistant/routing/routes.dart';
import 'package:scaffassistant/feature/settings/controllers/setting_controller.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // VERY IMPORTANT: initialize settings controller globally
  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    final route = UserStatus.getIsLoggedIn()
        ? RouteNames.initial
        : RouteNames.onboarding;

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scaff Assistant',

      theme: lightTheme,
      darkTheme: darkTheme,

      // DYNAMIC THEME MODE
      themeMode:
      settings.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

      initialRoute: route,
      getPages: Routes.pages,
    ));
  }
}
