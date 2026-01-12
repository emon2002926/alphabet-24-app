import 'package:flutter/material.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

class MatchStatCard extends StatelessWidget {
  final String title;
  final List<List<String>> rows;

  const MatchStatCard({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: STextTheme.headLineBold()),
          const SizedBox(height: 8),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(r[0], style: STextTheme.headLineBold().copyWith(fontSize: 12)),
                Text(r[1], style: STextTheme.headLineBold().copyWith(fontSize: 12)),
                Text(r[2], style: STextTheme.headLineBold().copyWith(fontSize: 12)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class MatchHeadToHeadCard extends StatelessWidget {
  const MatchHeadToHeadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text('Head to Head (5)', style: STextTheme.headLineBold()),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/UEL.png', width: 50),
              Column(children: [
                Text('2', style: STextTheme.headLineBold().copyWith(fontSize: 20)),
                const Text('WINS'),
              ]),
              Column(children: [
                Text('1', style: STextTheme.headLineBold().copyWith(fontSize: 20)),
                const Text('DRAWS'),
              ]),
              Column(children: [
                Text('2', style: STextTheme.headLineBold().copyWith(fontSize: 20)),
                const Text('LOSSES'),
              ]),
              Image.asset('assets/images/UEL.png', width: 50),
            ],
          ),
        ],
      ),
    );
  }
}
