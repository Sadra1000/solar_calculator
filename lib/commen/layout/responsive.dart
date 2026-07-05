import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double largeScreenMinWidth = 600;
  static const double contentMaxWidth = 1200;
  static const double resultContentMaxWidth = 1000;
}

bool isLargeScreen(double maxWidth) =>
    maxWidth > AppBreakpoints.largeScreenMinWidth;

Widget constrainContent({
  required Widget child,
  double maxWidth = AppBreakpoints.contentMaxWidth,
}) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

double adaptiveGridItemSize(double maxWidth) {
  if (maxWidth > AppBreakpoints.largeScreenMinWidth) {
    return 96;
  }
  if (maxWidth > 400) {
    return 88;
  }
  return 76;
}

double adaptiveGroupCardHeight(double maxWidth) {
  return maxWidth > AppBreakpoints.largeScreenMinWidth ? 72 : 64;
}

double adaptiveDialogHeight(double maxHeight) => maxHeight * 0.5;
