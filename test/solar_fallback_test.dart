import 'package:flutter_test/flutter_test.dart';
import 'package:solar_calculator/commen/helpers/solar_fallback.dart';
import 'package:solar_calculator/features/solar/iran_cities.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';

void main() {
  final sizing = SolarCalculator.calculate(
    dailyKwh: 5,
    peakLoadKw: 2,
    city: cityById('tehran'),
  );

  test('renders the local recommendation in English', () {
    final text = SolarFallback.buildRecommendation(
      dailyKwh: 5,
      monthlyKwh: 152,
      yearlyKwh: 1825,
      solarSizing: sizing,
      languageCode: 'en',
      city: 'Tehran',
      usdToToman: 200000,
    );

    expect(text, contains('## Local recommendation'));
    expect(text, contains('### Solar panels'));
    expect(
      text,
      contains('${sizing.inverterCapacityKw.toStringAsFixed(1)} kW'),
    );
  });

  test('renders the local recommendation in Persian', () {
    final text = SolarFallback.buildRecommendation(
      dailyKwh: 5,
      monthlyKwh: 152,
      yearlyKwh: 1825,
      solarSizing: sizing,
      languageCode: 'fa',
      city: 'تهران',
      usdToToman: 200000,
    );

    expect(text, contains('## توصیه محلی'));
    expect(text, contains('### پنل‌های خورشیدی'));
  });
}
