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
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceContainerHighest: Color(0xFFE0E2EC),
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
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceContainerHighest: Color(0xFF43474E),
  onSurfaceVariant: Color(0xFFC3C7CF),
  outline: Color(0xFF8D9199),
  inverseSurface: Color(0xFFE3E2E6),
  onInverseSurface: Color(0xFF1A1C1E),
  inversePrimary: Color(0xFF005DB5),
  shadow: Color(0xFF000000),
);

class MyTheme {
  static const _fontFamily = 'Vazirmatn';

  static ThemeData lightTheme({bool usePersianFont = true}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: usePersianFont ? _fontFamily : null,
    );
  }

  static ThemeData darkTheme({bool usePersianFont = true}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: usePersianFont ? _fontFamily : null,
    );
  }
}
