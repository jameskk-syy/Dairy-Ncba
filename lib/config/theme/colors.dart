import 'package:flutter/material.dart';

class AppColors {
  static const fadeTeal = Color.fromARGB(255, 222, 255, 252);
  static const Color primaryText = Colors.black;
  static const int _teal = 0xFF00ADB5;
  static const MaterialColor teal = MaterialColor(
    _teal,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(_teal),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );

  static const gray = 0xEEEEEEEE;
  static const MaterialColor grey = MaterialColor(gray, {500: Color(gray)});

  static const Color darkGrey = Color(0xff7C7C7C);
  static const Color orange = Color(0xffEF9920);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color appgreen = Color(0xFF006838);
  static const Color dark = Color(0xFF1A1A1A);
  static const Color lightGreen = Color(0xFF00E5FF);
  static const Color red = Color(0xFFE60000);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: teal,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF80DEEA),
    onPrimaryContainer: Color(0xFF80DEEA),
    secondary: Color(0xFF0097A7),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD2E8D4),
    onSecondaryContainer: Color(0xFF0D1F13),
    tertiary: Color(0xFF3B6470),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBEEAF7),
    onTertiaryContainer: Color(0xFF001F26),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFBFDF8),
    onSurface: Color(0xFF191C1A),
    surfaceContainerHighest: Color(0xFFDCE5DB),
    onSurfaceVariant: Color(0xFF414942),
    outline: Color(0xFF717971),
    //onInverseSurface: Color(0xFFF0F1EC),
    onInverseSurface: Color(0xFFFBFDF8),
    inverseSurface: Color(0xFF2E312E),
    inversePrimary: Color(0xFF80DEEA),
    shadow: Color(0xFF000000),
    surfaceTint: teal,
    outlineVariant: Color(0xFFC0C9BF),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7BDA9C),
    onPrimary: teal,
    primaryContainer: Color(0xFF00838F),
    onPrimaryContainer: Color(0xFF97F7B7),
    secondary: Color(0xFFB6CCB9),
    onSecondary: Color(0xFF223527),
    secondaryContainer: Color(0xFF384B3D),
    onSecondaryContainer: Color(0xFFD2E8D4),
    tertiary: Color(0xFFA3CDDA),
    onTertiary: Color(0xFF023640),
    tertiaryContainer: Color(0xFF214C57),
    onTertiaryContainer: Color(0xFFBEEAF7),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF191C1A),
    onSurface: Color(0xFFE1E3DE),
    surfaceContainerHighest: Color(0xFF414942),
    onSurfaceVariant: Color(0xFFC0C9BF),
    outline: Color(0xFF8B938A),
    onInverseSurface: Color(0xFF191C1A),
    inverseSurface: Color(0xFFE1E3DE),
    inversePrimary: Color(0xFF006D3D),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF7BDA9C),
    outlineVariant: Color(0xFF414942),
    scrim: Color(0xFF000000),
  );
}
