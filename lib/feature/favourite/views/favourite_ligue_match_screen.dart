import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';

import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/favourite_controller.dart';
import '../widgets/favourite_igue_football_tab.dart';
import 'package:get/get.dart';

class FavouriteLigueMatchScreen extends StatelessWidget {
  const FavouriteLigueMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller with Get.put to ensure it's created
    final FavouriteController controller = Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'Favourites', isHomeScreen: true),
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

              // ---------- Horizontal Date Selector ----------
              FavouriteDateSelectorWidget(),

              // ---------- TabBar View ----------
              Expanded(
                child: TabBarView(
                  children: const [
                    FavouriteIgueFootballTab(),
                    Center(child: Text("🏀 Basketball Coming Soon")),
                    Center(child: Text("🎾 Tennis Coming Soon")),
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

// Replace the existing date selector in FavouriteLigueMatchScreen with this widget

class FavouriteDateSelectorWidget extends StatefulWidget {
  const FavouriteDateSelectorWidget({super.key});

  @override
  State<FavouriteDateSelectorWidget> createState() => _FavouriteDateSelectorWidgetState();
}

class _FavouriteDateSelectorWidgetState extends State<FavouriteDateSelectorWidget> {
  final ScrollController scrollController = ScrollController();
  bool hasScrolledToToday = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavouriteController controller = Get.find<FavouriteController>();

    return SizedBox(
      height: 70,
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

            final dayName = DateFormat('EEE').format(date).toUpperCase();
            final dayNumber = date.day.toString();
            final monthName = DateFormat('MMM').format(date);

            return Padding(
              padding: EdgeInsets.only(right: DynamicSize.medium(context)),
              child: GestureDetector(
                onTap: () {
                  controller.selectDate(date);
                  HapticFeedback.lightImpact();
                },
                child: SizedBox(
                  width: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Day name (MON, TUE, etc.)
                        Text(
                          dayName,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? SColor.primary
                                : isToday
                                ? SColor.primary.withOpacity(0.7)
                                : null,
                          ),
                        ),
                        // Date number
                        Text(
                          dayNumber,
                          style: STextTheme.headLine().copyWith(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? SColor.primary
                                : isToday
                                ? SColor.primary.withOpacity(0.7)
                                : null,
                          ),
                        ),
                        // Month (optional, shows below date)
                        if (date.day == 1 || isSelected || isToday)
                          Text(
                            monthName,
                            style: STextTheme.headLine().copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? SColor.primary
                                  : isToday
                                  ? SColor.primary.withOpacity(0.7)
                                  : Colors.grey[600],
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

