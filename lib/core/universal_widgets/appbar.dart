import 'package:flutter/material.dart';

import '../theme/SColor.dart';
import '../theme/text_theme.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomeScreen;

  const SAppBar({
    super.key,
    required this.title,
    this.isHomeScreen = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: STextTheme.headLine().copyWith(fontSize: 18),
      ),
      centerTitle: true,
      backgroundColor: SColor.bodyColor,
      elevation: 0,
      leading: isHomeScreen
          ? null
          : GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: SColor.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}