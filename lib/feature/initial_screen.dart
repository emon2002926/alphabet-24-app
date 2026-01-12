import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/favourite/views/favourite_ligue_match_screen.dart';
import 'package:scaffassistant/feature/home/screens/home_screen.dart';
import 'package:scaffassistant/feature/settings/screens/settings_screen.dart';
import 'package:scaffassistant/feature/settings/controllers/setting_controller.dart';
import 'ligue/views/ligue_screen.dart';
import 'live_game/views/live_game_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _currentIndex = 0;
  final controller = Get.put(SettingsController());

  final List<Widget> _screens = const [
    HomeScreen(),
    LiveGameScreen(),
    FavouriteScreen(),
    LigueScreen(),
    SettingsScreen(),
  ];

  final List<NavItem> _navItems = const [
    NavItem(iconPath: IconPath.home, label: 'Home'),
    NavItem(iconPath: IconPath.live, label: 'LIVE'),
    NavItem(iconPath: IconPath.favourite, label: 'Favourite'),
    NavItem(iconPath: IconPath.ligue, label: 'Ligues'),
    NavItem(iconPath: IconPath.more, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: Obx(
            () {
          // Now we're observing controller.isDarkMode.value which is observable
          final isDark = controller.isDarkMode.value;
          final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _navItems.length,
                        (index) => _buildNavItem(index, isDark),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    final item = _navItems[index];
    final isActive = _currentIndex == index;
    final activeColor = SColor.primary ?? Colors.blue;
    final inactiveColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: activeColor.withOpacity(0.1),
        highlightColor: activeColor.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.iconPath,
                height: 26,
                width: 26,
                color: isActive ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String iconPath;
  final String label;

  const NavItem({required this.iconPath, required this.label});
}