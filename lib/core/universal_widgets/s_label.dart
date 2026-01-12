import 'package:flutter/material.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/text_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(
        horizontal: DynamicSize.medium(context),
        vertical: DynamicSize.small(context) * 0.8,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: STextTheme.headLineBold().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (score != null)
            Text(
              score!,
              style: STextTheme.headLineBold().copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}