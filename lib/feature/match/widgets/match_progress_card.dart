import 'package:flutter/material.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

class MatchProgressCard extends StatelessWidget {
  final String title;
  final String leftIcon;
  final String rightIcon;
  final double leftPercent;
  final double drawPercent;
  final double rightPercent;
  final Color color1;
  final Color color2;
  final Color color3;

  const MatchProgressCard({
    super.key,
    required this.title,
    required this.leftIcon,
    required this.rightIcon,
    required this.leftPercent,
    required this.drawPercent,
    required this.rightPercent,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(title, style: STextTheme.headLine().copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(leftIcon, height: 20),
                Text('Draw ${(drawPercent * 100).toStringAsFixed(0)}%', style: STextTheme.subHeadLine()),
                Image.asset(rightIcon, height: 20),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: (leftPercent * 100).toInt(),
                  child: Container(height: 6, decoration: BoxDecoration(color: color1, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)))),
                ),
                Expanded(
                  flex: (drawPercent * 100).toInt(),
                  child: Container(height: 6, color: color2),
                ),
                Expanded(
                  flex: (rightPercent * 100).toInt(),
                  child: Container(height: 6, decoration: BoxDecoration(color: color3, borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
