import 'package:flutter/material.dart';

class AppStyles {
  static const Color white = Color(0xFFFFFFFF);
  static const Color silver = Color(0xFFC3C3C3);
  static const Color orange = Colors.orange;

  static final defaultTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.orange,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: orange,
    ),
  );

  // TextStyles
  static const TextStyle textCategoryTitle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: silver,
  );

  static const TextStyle textDateSelection = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 26,
    color: white,
  );

  static const TextStyle subjectHintText = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: white,
  );

  static const TextStyle modalBottomTitle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: silver,
  );
}

class Separators {
  static const tinySeparator = SizedBox(height: 4, width: 4);
  static const smallSeparator = SizedBox(height: 8, width: 8);
  static const mediumSeparator = SizedBox(height: 16, width: 16);
  static const largeSeparator = SizedBox(height: 32, width: 32);
}

class NoScrollIndicator extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
