import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF001B42),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD1E4FF),
  onPrimaryContainer: Color(0xFF001B3E),
  secondary: Color(0xFFAC6C00),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDDB7),
  onSecondaryContainer: Color(0xFF2B1700),
  tertiary: Color(0xFF386A20),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFB9F397),
  onTertiaryContainer: Color(0xFF042100),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFDFBFF),
  onBackground: Color(0xFF1A1C1E),
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFE0E2EC),
  onSurfaceVariant: Color(0xFF43474E),
  outline: Color(0xFF74777F),
  inverseSurface: Color(0xFF2F3033),
  onInverseSurface: Color(0xFFF1F0F4),
  inversePrimary: Color(0xFFA0C9FF),
  shadow: Color(0xFF000000),
);
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFA0C9FF),
  onPrimary: Color(0xFF003064),
  primaryContainer: Color(0xFF00468D),
  onPrimaryContainer: Color(0xFFD1E4FF),
  secondary: Color(0xFFFFB95A),
  onSecondary: Color(0xFF482A00),
  secondaryContainer: Color(0xFF674000),
  onSecondaryContainer: Color(0xFFFFDDB7),
  tertiary: Color(0xFF9ED67E),
  onTertiary: Color(0xFF0C3900),
  tertiaryContainer: Color(0xFF20510A),
  onTertiaryContainer: Color(0xFFB9F397),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1C1E),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF43474E),
  onSurfaceVariant: Color(0xFFC3C7CF),
  outline: Color(0xFF8D9199),
  inverseSurface: Color(0xFFE3E2E6),
  onInverseSurface: Color(0xFF1A1C1E),
  inversePrimary: Color(0xFF005DB5),
  shadow: Color(0xFF000000),
);

class MyTheme {
  // 1. Color Scheme for Light Theme

  // 2. Color Scheme for Dark Theme

  // 3. Custom Text Theme based on Material 3 Typography
  // You can replace 'null' with your desired font family, for example, 'Vazirmatn'

  // 4. Final ThemeData objects
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      // You can add other theme properties here like appbarTheme, elevatedButtonTheme, etc.
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      // You can add other theme properties here like appbarTheme, elevatedButtonTheme, etc.
    );
  }
}
