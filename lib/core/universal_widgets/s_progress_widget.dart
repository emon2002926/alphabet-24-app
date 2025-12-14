import 'package:flutter/material.dart';
import '../../../core/const/size_const/dynamic_size.dart';
import '../../../core/theme/SColor.dart';
import '../../../core/theme/text_theme.dart';

class SProgressWidget extends StatelessWidget {
  final String label; // e.g. score "1-0"
  final double value;  // probability 0.0 - 1.0

  const SProgressWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DynamicSize.medium(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: STextTheme.headLine().copyWith(fontSize: 14)),
          SizedBox(height: DynamicSize.extraSmall()),
          SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
              color: SColor.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
