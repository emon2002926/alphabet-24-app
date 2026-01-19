import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/settings/controllers/setting_controller.dart';
import 'package:scaffassistant/routing/route_name.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/user_controller.dart';
import '../../auth/screens/password_change_screen.dart';
import '../../subscription/views/subscription_screen.dart';
import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    const privacyPolicyUrl = 'https://www.example.com/privacy';
    const helpSupportUrl = 'https://www.example.com/support';
    const termsConditionsUrl = 'https://www.example.com/terms';
    final profileController = Get.put(UserController());
    final profile = profileController.userProfile.value;
    profileController.fetchUserProfile();

    return Obx(
          () {
        final isDark = controller.isDarkMode.value;
        final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            title: Text(
              'Settings',
              style: STextTheme.headLineBold().copyWith(color: textColor, fontSize: 20),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: textColor),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(DynamicSize.large(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, textColor, profile?.fullName, profile?.phoneNumber, profile?.profilePictureUrl),
                SizedBox(height: DynamicSize.large(context)),

                Text(
                  'Settings & Profile',
                  style: STextTheme.headLineBold().copyWith(fontSize: 18, color: textColor),
                ),
                SizedBox(height: DynamicSize.medium(context)),

                /// 🌙 Dark Mode Switch
                SettingTile(
                  leading: Image.asset(IconPath.theme, width: 30, height: 30),
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: SColor.primary,
                    onChanged: controller.toggleDarkMode,
                  ),
                  isDarkMode: isDark,
                ),

                SettingTile(
                  leading: Image.asset(IconPath.change, width: 30, height: 30),
                  title: 'Password Change',
                  onTap: () => Get.to(() => const PasswordChangeScreen()),
                  isDarkMode: isDark,
                ),

                SettingTile(
                  leading: Image.asset(IconPath.notification, width: 30, height: 30),
                  title: 'Terms & Conditions',
                  onTap: () => launchUrl(
                    Uri.parse(termsConditionsUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  isDarkMode: isDark,
                ),

                SettingTile(
                  leading: Image.asset(IconPath.setting, width: 30, height: 30),
                  title: 'Account Settings',
                  onTap: () => Get.to(() => const AccountScreen()),
                  isDarkMode: isDark,
                ),

                SettingTile(
                  leading: Image.asset(IconPath.support, width: 30, height: 30),
                  title: 'Help & Support',
                  onTap: () => launchUrl(
                    Uri.parse(helpSupportUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  isDarkMode: isDark,
                ),

                SettingTile(
                  leading: Image.asset(IconPath.lock, width: 30, height: 30),
                  title: 'Privacy & Policy',
                  onTap: () => launchUrl(
                    Uri.parse(privacyPolicyUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  isDarkMode: isDark,
                ),

                Obx(() => SettingTile(
                  leading: controller.isDeleting.value
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                      : Image.asset(IconPath.exitIcon, width: 24, height: 24),
                  title: 'Delete Account',
                  onTap: controller.isDeleting.value
                      ? null
                      : () {
                    controller.deleteAccount();
                  },
                  isDarkMode: isDark,
                )),

                SettingTile(
                  leading: Image.asset(IconPath.exitIcon, width: 24, height: 24),
                  title: 'Logout',
                  onTap: () {
                    controller.logOut();
                  },
                  isDarkMode: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, Color textColor,
      String? profileName, String? profileEmail, String? profilePictureUrl) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: SColor.primary,
          radius: 20,
          child: ClipOval(
            child: profilePictureUrl != null && profilePictureUrl.isNotEmpty
                ? Image.network(
              profilePictureUrl,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImagePath.avater,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                );
              },
            )
                : Image.asset(
              ImagePath.avater,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
        ),
        SizedBox(width: DynamicSize.medium(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileName ?? 'User Name',
                style: STextTheme.headLineBold().copyWith(fontSize: 18, color: textColor),
              ),
              Text(
                profileEmail ?? 'Email',
                style: STextTheme.subHeadLine().copyWith(color: textColor),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => const SubscriptionScreen()),
          child: Text('Upgrade', style: STextTheme.headLineBold().copyWith(color: SColor.primary)),
        )
      ],
    );
  }
}

class SettingTile extends StatelessWidget {
  final bool isDarkMode;
  final Widget leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.leading,
    required this.title,
    required this.isDarkMode,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: Text(
            title,
            style: STextTheme.headLineNormal().copyWith(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}