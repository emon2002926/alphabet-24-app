import 'package:flutter/material.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

class MatchListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leagues;
  final bool showDivider;

  const MatchListWidget({
    super.key,
    required this.leagues,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      itemCount: leagues.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => showDivider
          ? const Divider(color: Colors.grey, height: 1)
          : const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final league = leagues[index];
        return GestureDetector(
          onTap: () {

          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Logo
                SizedBox(
                  width: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      league['logo'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        league['name'],
                        style: STextTheme.subHeadLine().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        league['name'], // replace with subtitle if available
                        style: STextTheme.headLine().copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Count section
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    league['count'].toString(),
                    style: STextTheme.subHeadLine().copyWith(
                      color: SColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
