import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaffassistant/feature/home/screens/home_screen.dart';
import '../../../core/theme/SColor.dart';
import '../../match/views/match_search_screen.dart';
import 'package:get/get.dart';
import '../widgets/live_football_tab.dart';

class LiveGameScreen extends StatefulWidget {
  final bool isShowBackButton;

  const LiveGameScreen({
    super.key,
    this.isShowBackButton = false,
  });

  @override
  State<LiveGameScreen> createState() => _LiveGameScreenState();
}

class _LiveGameScreenState extends State<LiveGameScreen> {
  String selectedSport = 'Football';
  final List<String> sports = ['Football', 'Basketball'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: SColor.bodyColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sport Selector Header Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Color(0xFF2C2C2C) : Color(0xFFE5E5E5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button - Left Side
                  if (widget.isShowBackButton)
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: SColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                  // Sport Dropdown
                  Expanded(
                    child: PopupMenuButton<String>(
                      initialValue: selectedSport,
                      offset: Offset(0, 50),
                      color: isDark ? Color(0xFF2C2C2C) : Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedSport,
                            style: GoogleFonts.roboto(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black,
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 1),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 32,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ],
                      ),
                      itemBuilder: (BuildContext context) {
                        return sports.map((String sport) {
                          final isSelected = sport == selectedSport;
                          return PopupMenuItem<String>(
                            value: sport,
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sport,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? SColor.primary
                                        : (isDark ? Colors.white : Colors.black),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: SColor.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (String newSport) {
                        setState(() {
                          selectedSport = newSport;
                        });
                      },
                    ),
                  ),

                  // Search Icon - Right Side
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MatchSearchScreen());
                    },
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Content based on selected sport
            Expanded(
              child: _buildSelectedSportContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSportContent() {
    switch (selectedSport) {
      case 'Football':
        return PredictedFootballTab();
      case 'Basketball':
        return DevelopmentPage();
      default:
        return PredictedFootballTab();
    }
  }
}