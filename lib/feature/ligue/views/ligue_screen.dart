import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/universal_widgets/basketball/basketball_league_list_widget.dart';
import 'package:scaffassistant/feature/home/screens/home_screen.dart';
import '../../home/controllers/sports_data/football_data/leage_list_controller.dart';
import '../widgets/ligue_basketball_tab.dart';
import '../widgets/ligue_football_tab.dart';
import 'package:get/get.dart';

class LigueScreen extends StatelessWidget {
  const LigueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'All Ligue', isHomeScreen: true),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Tab Bar ----------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DynamicSize.medium(context),
                  vertical: DynamicSize.small(context),
                ),
                child: Container(
                  height: 40,
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
                      Tab(text: 'Tennis'),
                    ],
                  ),
                ),
              ),

              // ---------- Horizontal Date Header ----------
              DateSelectorWidget(),

              // ---------- TabBar View ----------
              Expanded(
                child: TabBarView(
                  children: const [
                    LigueFootballTab(),
                    LigueBasketballTab(),
                    DevelopmentPage(),
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

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({super.key});

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  final ScrollController scrollController = ScrollController();
  bool hasScrolledToToday = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LeagueListController controller = Get.find<LeagueListController>();

    return SizedBox(
      height: 80, // Increased from 70 to 80
      child: Obx(() {
        final currentSelectedDate = controller.selectedDate.value;
        final isFilterActive = controller.isDateFilterActive.value;

        // Auto-scroll to today only once on first build
        if (!hasScrolledToToday && controller.dateRange.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              final todayIndex = controller.dateRange.indexWhere(
                      (date) => _isToday(date)
              );
              if (todayIndex != -1) {
                final screenWidth = MediaQuery.of(context).size.width;
                final scrollPosition = (72.0 * todayIndex) - (screenWidth / 2) + 36;

                scrollController.animateTo(
                  scrollPosition > 0 ? scrollPosition : 0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              }
            }
          });
          hasScrolledToToday = true;
        }

        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: DynamicSize.medium(context),
            vertical: DynamicSize.small(context),
          ),
          scrollDirection: Axis.horizontal,
          itemCount: controller.dateRange.length,
          itemBuilder: (context, index) {
            final date = controller.dateRange[index];
            final isToday = _isToday(date);
            final isSelected = isFilterActive && _isSameDay(date, currentSelectedDate);

            final dayName = DateFormat('EEE').format(date).toUpperCase(); // THU, FRI
            final dayNumber = date.day.toString(); // 11, 12, 13
            final monthName = DateFormat('MMM').format(date); // Dec, Jan

            return Padding(
              padding: EdgeInsets.only(right: DynamicSize.medium(context)),
              child: GestureDetector(
                onTap: () {
                  controller.selectDate(date);
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? SColor.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? SColor.primary
                          : isToday
                          ? SColor.primary.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: SColor.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ]
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8), // Add padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Important: minimize size
                      children: [
                        // Day Name (THU, FRI)
                        Text(
                          dayName,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 9,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                ? SColor.primary
                                : Colors.grey[600],
                            height: 1.0, // Reduce line height
                          ),
                        ),
                        SizedBox(height: 2),
                        // Date Number (11, 12)
                        Text(
                          dayNumber,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                ? SColor.primary
                                : Colors.grey[800],
                            height: 1.0, // Reduce line height
                          ),
                        ),
                        SizedBox(height: 1),
                        // Month Name (Dec, Jan)
                        Text(
                          monthName,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : isToday
                                ? SColor.primary.withOpacity(0.8)
                                : Colors.grey[600],
                            height: 1.0, // Reduce line height
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}