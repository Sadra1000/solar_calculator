import 'package:flutter/material.dart';
import 'package:solar_calculator/commen/constants.dart';

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

EdgeInsets adaptiveGroupCardPadding(double maxWidth) {
  if (maxWidth > AppBreakpoints.largeScreenMinWidth) {
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  }
  if (maxWidth < 400) {
    return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  }
  return const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
}

double adaptiveDialogHeight(double maxHeight) => maxHeight * 0.5;
