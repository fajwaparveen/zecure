import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final int themeLight = 1;
  static final int themeDark = 2;

  // Change Font Family Default
  static final fontFamily = GoogleFonts.poppins;

  AppTheme._();

  static CustomAppTheme getCustomAppTheme(int themeMode) {
    if (themeMode == themeLight) {
      return lightCustomAppTheme;
    } else if (themeMode == themeDark) {
      return darkCustomAppTheme;
    }
    return darkCustomAppTheme;
  }

  static FontWeight _getFontWeight(int weight) {
    switch (weight) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }

  static TextStyle getTextStyle(
      TextStyle textStyle, {
        int fontWeight = 500,
        bool muted = false,
        bool xMuted = false,
        double letterSpacing = 0.15,
        Color? color,
        TextDecoration decoration = TextDecoration.none,
        double? height,
        double wordSpacing = 0,
        double? fontSize,
      }) {
    double finalFontSize = fontSize ?? textStyle.fontSize ?? 14;

    Color finalColor;
    if (color == null) {
      finalColor = xMuted
          ? textStyle.color!.withAlpha(160)
          : (muted ? textStyle.color!.withAlpha(200) : textStyle.color!);
    } else {
      finalColor = xMuted
          ? color.withAlpha(160)
          : (muted ? color.withAlpha(200) : color);
    }

    return fontFamily(
      fontSize: finalFontSize,
      fontWeight: _getFontWeight(fontWeight),
      letterSpacing: letterSpacing,
      color: finalColor,
      decoration: decoration,
      height: height,
      wordSpacing: wordSpacing,
    );
  }

  // Light AppBar TextTheme
  static final TextTheme lightAppBarTextTheme = TextTheme(
    displayLarge: fontFamily(
        textStyle: TextStyle(fontSize: 102, color: Color(0xff495057))),
    displayMedium: fontFamily(
        textStyle: TextStyle(fontSize: 64, color: Color(0xff495057))),
    displaySmall: fontFamily(
        textStyle: TextStyle(fontSize: 51, color: Color(0xff495057))),
    headlineMedium: fontFamily(
        textStyle: TextStyle(fontSize: 36, color: Color(0xff495057))),
    headlineSmall: fontFamily(
        textStyle: TextStyle(fontSize: 25, color: Color(0xff495057))),
    titleLarge: fontFamily(
        textStyle: TextStyle(fontSize: 18, color: Color(0xff495057))),
    titleMedium: fontFamily(
        textStyle: TextStyle(fontSize: 17, color: Color(0xff495057))),
    titleSmall: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff495057))),
    bodyLarge: fontFamily(
        textStyle: TextStyle(fontSize: 16, color: Color(0xff495057))),
    bodyMedium: fontFamily(
        textStyle: TextStyle(fontSize: 14, color: Color(0xff495057))),
    labelLarge: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff495057))),
    bodySmall: fontFamily(
        textStyle: TextStyle(fontSize: 13, color: Color(0xff495057))),
    labelSmall: fontFamily(
        textStyle: TextStyle(fontSize: 11, color: Color(0xff495057))),
  );

  // Dark AppBar TextTheme
  static final TextTheme darkAppBarTextTheme = TextTheme(
    displayLarge: fontFamily(
        textStyle: TextStyle(fontSize: 102, color: Color(0xffffffff))),
    displayMedium: fontFamily(
        textStyle: TextStyle(fontSize: 64, color: Color(0xffffffff))),
    displaySmall: fontFamily(
        textStyle: TextStyle(fontSize: 51, color: Color(0xffffffff))),
    headlineMedium: fontFamily(
        textStyle: TextStyle(fontSize: 36, color: Color(0xffffffff))),
    headlineSmall: fontFamily(
        textStyle: TextStyle(fontSize: 25, color: Color(0xffffffff))),
    titleLarge: fontFamily(
        textStyle: TextStyle(fontSize: 20, color: Color(0xffffffff))),
    titleMedium: fontFamily(
        textStyle: TextStyle(fontSize: 17, color: Color(0xffffffff))),
    titleSmall: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xffffffff))),
    bodyLarge: fontFamily(
        textStyle: TextStyle(fontSize: 16, color: Color(0xffffffff))),
    bodyMedium: fontFamily(
        textStyle: TextStyle(fontSize: 14, color: Color(0xffffffff))),
    labelLarge: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xffffffff))),
    bodySmall: fontFamily(
        textStyle: TextStyle(fontSize: 13, color: Color(0xffffffff))),
    labelSmall: fontFamily(
        textStyle: TextStyle(fontSize: 11, color: Color(0xffffffff))),
  );

  // Light TextTheme
  static final TextTheme lightTextTheme = TextTheme(

    displayLarge: fontFamily(
        textStyle: TextStyle(fontSize: 102, color: Color(0xff4a4c4f))),
    displayMedium: fontFamily(
        textStyle: TextStyle(fontSize: 64, color: Color(0xff4a4c4f))),
    displaySmall: fontFamily(
        textStyle: TextStyle(fontSize: 51, color: Color(0xff4a4c4f))),
    headlineMedium: fontFamily(
        textStyle: TextStyle(fontSize: 36, color: Color(0xff4a4c4f))),
    headlineSmall: fontFamily(
        textStyle: TextStyle(fontSize: 25, color: Color(0xff4a4c4f))),
    titleLarge: fontFamily(
        textStyle: TextStyle(fontSize: 18, color: Color(0xff4a4c4f))),
    titleMedium: fontFamily(
        textStyle: TextStyle(fontSize: 17, color: Color(0xff4a4c4f))),
    titleSmall: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
    bodyLarge: fontFamily(
        textStyle: TextStyle(fontSize: 16, color: Color(0xff4a4c4f))),
    bodyMedium: fontFamily(
        textStyle: TextStyle(fontSize: 14, color: Color(0xff4a4c4f))),
    labelLarge: fontFamily(
        textStyle: TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
    bodySmall: fontFamily(
        textStyle: TextStyle(fontSize: 13, color: Color(0xff4a4c4f))),
    labelSmall: fontFamily(
        textStyle: TextStyle(fontSize: 11, color: Color(0xff4a4c4f))),
  );

  // Dark TextTheme
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: fontFamily(textStyle: TextStyle(fontSize: 102, color: Colors.white)),
    displayMedium: fontFamily(textStyle: TextStyle(fontSize: 64, color: Colors.white)),
    displaySmall: fontFamily(textStyle: TextStyle(fontSize: 51, color: Colors.white)),
    headlineMedium: fontFamily(textStyle: TextStyle(fontSize: 36, color: Colors.white)),
    headlineSmall: fontFamily(textStyle: TextStyle(fontSize: 25, color: Colors.white)),
    titleLarge: fontFamily(textStyle: TextStyle(fontSize: 18, color: Colors.white)),
    titleMedium: fontFamily(textStyle: TextStyle(fontSize: 17, color: Colors.white)),
    titleSmall: fontFamily(textStyle: TextStyle(fontSize: 15, color: Colors.white)),
    bodyLarge: fontFamily(textStyle: TextStyle(fontSize: 16, color: Colors.white)),
    bodyMedium: fontFamily(textStyle: TextStyle(fontSize: 14, color: Colors.white)),
    labelLarge: fontFamily(textStyle: TextStyle(fontSize: 15, color: Colors.white)),
    bodySmall: fontFamily(textStyle: TextStyle(fontSize: 13, color: Colors.white)),
    labelSmall: fontFamily(textStyle: TextStyle(fontSize: 11, color: Colors.white)),
  );

  // Light ThemeData
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF27ae61),
    canvasColor: Colors.transparent,
    // backgroundColor: Colors.white,
    scaffoldBackgroundColor: Color(0xffffffff),
    appBarTheme: AppBarTheme(
      toolbarTextStyle: lightAppBarTextTheme.bodyMedium,
      titleTextStyle: lightAppBarTextTheme.titleLarge,
      actionsIconTheme: IconThemeData(
        color: Color(0xff495057),
      ),
      color: Color(0xffffffff),
      iconTheme: IconThemeData(color: Color(0xff495057), size: 24),
    ),
    navigationRailTheme: NavigationRailThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF27ae61), opacity: 1, size: 24),
      unselectedIconTheme: IconThemeData(color: Color(0xff495057), opacity: 1, size: 24),
      backgroundColor: Color(0xffffffff),
      elevation: 3,
      selectedLabelTextStyle: TextStyle(color: Color(0xFF27ae61)),
      unselectedLabelTextStyle: TextStyle(color: Color(0xff495057)),
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF27ae61),
      onPrimary: Colors.white,
      // primaryVariant: Color(0xFF3aa668),
      secondary: Color(0xff495057),
      // secondaryVariant: Color(0xff3cd278),
      onSecondary: Colors.white,
      surface: Color(0xffe2e7f1),
      background: Color(0xfff3f4f7),
      onBackground: Color(0xff495057),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
    textTheme: lightTextTheme,
    iconTheme: IconThemeData(color: Color(0xff495057)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Color(0xffd9d9d9)),
      ),
    ),
  );

  // Dark ThemeData
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff27ae61),
    canvasColor: Colors.transparent,
    // backgroundColor: Color(0xff21252a),
    scaffoldBackgroundColor: Color(0xff21252a),
    appBarTheme: AppBarTheme(
      toolbarTextStyle: darkAppBarTextTheme.bodyMedium,
      titleTextStyle: darkAppBarTextTheme.titleLarge,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      color: Color(0xff21252a),
      iconTheme: IconThemeData(color: Colors.white, size: 24),
    ),
    navigationRailTheme: NavigationRailThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xff37404a), opacity: 1, size: 24),
      unselectedIconTheme: IconThemeData(color: Color(0xffd1d1d1), opacity: 1, size: 24),
      backgroundColor: Color(0xff37404a),
      elevation: 3,
      selectedLabelTextStyle: TextStyle(color: Color(0xff37404a)),
      unselectedLabelTextStyle: TextStyle(color: Color(0xffd1d1d1)),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xff27ae61),
      onPrimary: Colors.white,
      // primaryVariant: Color(0xff3aa668),
      secondary: Color(0xffd1d1d1),
      // secondaryVariant: Color(0xff3cd278),
      onSecondary: Colors.black,
      surface: Color(0xff273142),
      background: Color(0xff21252a),
      onBackground: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xff2d3741),
      shadowColor: Colors.black.withOpacity(0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
    textTheme: darkTextTheme,
    iconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Color(0xff4a5568)),
      ),
    ),
  );

  static NavigationBarTheme getNavigationThemeFromMode(int themeMode) {
    if (themeMode == themeLight) {
      return NavigationBarTheme(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF27ae61),
        unselectedItemColor: Color(0xff495057),
        selectedOverlayColor: Color(0x383d63ff),
      );
    } else if (themeMode == themeDark) {
      return NavigationBarTheme(
        backgroundColor: Color(0xff37404a),
        selectedItemColor: Color(0xff37404a),
        unselectedItemColor: Color(0xffd1d1d1),
        selectedOverlayColor: Color(0xffffffff),
      );
    }
    return NavigationBarTheme();
  }
}

class NavigationBarTheme {
  Color? backgroundColor;
  Color? selectedItemColor;
  Color? unselectedItemColor;
  Color? selectedOverlayColor;

  NavigationBarTheme({
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedOverlayColor,
  });
}

class CustomAppTheme {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color backgroundVariant;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;

  CustomAppTheme({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.backgroundVariant,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
  });
}

final CustomAppTheme lightCustomAppTheme = CustomAppTheme(
  primary: Color(0xFF27ae61),
  secondary: Color(0xff495057),
  background: Color(0xffffffff),
  backgroundVariant: Color(0xffe2e7f1),
  surface: Color(0xffffffff),
  error: Color(0xfff44336),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onBackground: Color(0xff495057),
  onSurface: Color(0xff495057),
  onError: Colors.white,
);

final CustomAppTheme darkCustomAppTheme = CustomAppTheme(
  primary: Color(0xff27ae61),
  secondary: Color(0xffd1d1d1),
  background: Color(0xff21252a),
  backgroundVariant: Color(0xff273142),
  surface: Color(0xff37404a),
  error: Color(0xfff44336),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onBackground: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
);
