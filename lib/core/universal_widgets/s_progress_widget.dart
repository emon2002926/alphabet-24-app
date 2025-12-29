import 'package:flutter/material.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';

class SProgressWidget extends StatelessWidget {
  final String label;
  final String homeValue;
  final String awayValue;
  final double homePercentage;
  final double awayPercentage;
  final bool isDark;

  const SProgressWidget({
    Key? key,
    required this.label,
    required this.homeValue,
    required this.awayValue,
    required this.homePercentage,
    required this.awayPercentage,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate normalized values for progress bar (0-100 scale)
    final double homeWidth = homePercentage;
    final double awayWidth = awayPercentage;

    // Colors based on theme
    final Color homeColor = isDark ? Color(0xFF2196F3) : Color(0xFF1E3A5F);
    final Color awayColor = isDark ? Color(0xFFFF4081) : Color(0xFFE91E63);
    final Color backgroundColor = isDark ? Color(0xFF2C2C2C) : Color(0xFFF5F5F5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              homeValue,
              style: STextTheme.scoureText(),
            ),
            Text(
              label,
              style: STextTheme.subHeadLine().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              awayValue,
              style: STextTheme.scoureText(),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              if (homeWidth > 0)
                Expanded(
                  flex: homeWidth.toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: homeColor,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(4),
                        right: awayWidth == 0 ? Radius.circular(4) : Radius.zero,
                      ),
                    ),
                  ),
                ),
              if (awayWidth > 0)
                Expanded(
                  flex: awayWidth.toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: awayColor,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                        left: homeWidth == 0 ? Radius.circular(4) : Radius.zero,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}