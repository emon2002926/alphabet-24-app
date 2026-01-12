import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/icon_path.dart';
import 'package:scaffassistant/core/universal_widgets/appbar.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';
import 'match_details_screen.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.bodyColor,
      appBar: SAppBar(title: 'Ligue Match'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // -------- Header Section --------
              Container(
                color: const Color(0xFFffe418).withOpacity(0.2),
                padding: EdgeInsets.all(DynamicSize.medium(context)),
                child: Row(
                  children: [
                    Image.asset(IconPath.barcelonaLogo, height: 50, width: 50),
                    SizedBox(width: DynamicSize.small(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'La Liga',
                            style: STextTheme.subHeadLine().copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Spain League', // example subtitle
                            style: STextTheme.headLineBold().copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: DynamicSize.small(context)),

              // -------- Match Card (Clickable) --------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: DynamicSize.medium(context)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  splashColor: SColor.primary.withOpacity(0.1),
                  onTap: () => Get.to(() => const MatchDetailsScreen()),
                  child: Container(
                    padding: EdgeInsets.all(DynamicSize.medium(context)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.star_border, color: SColor.primary, size: 24),
                        SizedBox(width: DynamicSize.small(context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(IconPath.barcelonaLogo, width: 24),
                                  const SizedBox(width: 4),
                                  Text(
                                    'PSG',
                                    style: STextTheme.headLineBold().copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Image.asset(IconPath.barcelonaLogo, width: 24),
                                  const SizedBox(width: 4),
                                  Text(
                                    'BFG',
                                    style: STextTheme.headLineBold().copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '9:34 AM',
                          style: STextTheme.subHeadLine().copyWith(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
