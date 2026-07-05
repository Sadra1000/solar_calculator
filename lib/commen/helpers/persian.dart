import 'package:flutter/material.dart';

extension PersianDigits on String {
  String toPersianDigits() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var out = this;
    for (var i = 0; i < english.length; i++) {
      out = out.replaceAll(english[i], persian[i]);
    }
    return out;
  }

  String localizedDigits(Locale locale) {
    if (locale.languageCode == 'fa') {
      return toPersianDigits();
    }
    return this;
  }

  String toWhPersian([Locale? locale]) {
    final value = locale == null ? this : localizedDigits(locale);
    return '${value}Wh';
  }

  String tokWhPersian([Locale? locale]) {
    final value = locale == null ? this : localizedDigits(locale);
    return '${value}kWh';
  }

  String tokWPersian([Locale? locale]) {
    final value = locale == null ? this : localizedDigits(locale);
    return '${value}kW';
  }

  String tokgPersian([Locale? locale]) {
    final value = locale == null ? this : localizedDigits(locale);
    return '${value}kg';
  }

  String toTomanPersian([Locale? locale]) {
    final value = locale == null ? this : localizedDigits(locale);
    return '$value تومان';
  }
}
