import 'package:flutter/material.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/theme/SColor.dart';

class SLabel extends StatelessWidget {
  final String title;
  final String? score;

  const SLabel({
    required this.title,
    this.score,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SColor.borderColor, // use your theme color if available
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(context),
        vertical: DynamicSize.small(context) * 0.6,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: STextTheme.headLine().copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: SColor.textPrimary, // match your theme
            ),
          ),
          const Spacer(),
          if (score != null)
            Text(
              score!,
              style: STextTheme.headLine().copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SColor.textSecondary, // theme match
              ),
            ),
        ],
      ),
    );
  }
}
