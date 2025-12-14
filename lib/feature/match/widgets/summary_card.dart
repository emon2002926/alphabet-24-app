import 'package:flutter/material.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/core/theme/SColor.dart';

class SummaryCard extends StatelessWidget {
  final String text;
  const SummaryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColor.bodyColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Summary', style: STextTheme.headLine().copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(text, style: STextTheme.headLine().copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
