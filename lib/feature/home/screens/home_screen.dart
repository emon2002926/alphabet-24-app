import 'package:flutter/material.dart';
          import 'package:scaffassistant/core/const/string_const/image_path.dart';
          import 'package:scaffassistant/core/theme/SColor.dart';
          import 'package:get/get.dart';
import 'package:scaffassistant/feature/home/widgets/basketball_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
          import '../../../core/user_controller.dart';

          import '../../../core/const/size_const/dynamic_size.dart';
          import '../../../core/theme/text_theme.dart';
import '../../match/views/match_search_screen.dart';
import '../widgets/football_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final profileController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: AppBar(
          backgroundColor: SColor.bodyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: SColor.primary,
                radius: 20,
                child: Image(
                  image: AssetImage(ImagePath.avater),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: DynamicSize.small(context)),
              Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back,',
                    style: STextTheme.normalText().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,

                    ),
                  ),
                  Text(
                    profileController.userProfile.value?.fullName ?? 'Guest',
                    style: STextTheme.scoureTextNormal().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: SColor.iconColor),
              onPressed: () {
                // Handle notification icon press
                Get.to(() =>
                    MatchSearchScreen());
              },
            ),
            SizedBox(width: DynamicSize.small(context)),
          ],
          toolbarHeight: 60,
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DynamicSize.medium(context),
                  vertical: DynamicSize.small(context),
                ),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: SColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.zero,
                    indicator: BoxDecoration(
                      color: SColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: SColor.primary,
                    splashBorderRadius: BorderRadius.circular(12),
                    tabs: const [
                      Tab(text: 'Football'),
                      Tab(text: 'Basketball'),
                      // Tab(text: 'Tennis'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FootballScreen(),
                    DevelopmentPage(),
                    // DevelopmentPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Demo Tab Screen Widget HomeScreen

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColor.bodyColor,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: SColor.bodyColor, // Soft card color from your theme
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated shimmer icon
              Shimmer(
                color: SColor.primary.withOpacity(0.7),
                child: Icon(
                  Icons.sports,
                  size: 60,
                  color: SColor.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Upcoming Feature',
                style: STextTheme.subHeadLine().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This section is coming soon for future games or events.',
                textAlign: TextAlign.center,
                style: STextTheme.headLine().copyWith(
                  fontSize: 14,
                  color: SColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
