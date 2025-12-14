import 'package:flutter/material.dart';

import '../theme/SColor.dart';
import '../theme/text_theme.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isHomeScreen = false;
  SAppBar({
    super.key,
    required this.title,
    this.isHomeScreen = false,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: STextTheme.headLine().copyWith(fontSize: 20),
      ),
      centerTitle: true,
      leading: isHomeScreen ? null : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: SColor.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      // actions: isHomeScreen
      //     ? null
      //     : [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 16.0),
      //     child: Icon(Icons.favorite, color: SColor.textPrimary, size: 28),
      //   )
      // ]
    );
  }
}