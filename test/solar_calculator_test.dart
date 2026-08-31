import 'package:flutter_test/flutter_test.dart';
import 'package:solar_calculator/features/solar/iran_cities.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';

void main() {
  group('SolarCalculator', () {
    test('returns a zero-sized system for zero consumption', () {
      final result = SolarCalculator.calculate(
        dailyKwh: 0,
        city: cityById('tehran'),
      );

      expect(result.panelCount, 0);
      expect(result.arrayCapacityKw, 0);
      expect(result.inverterCapacityKw, 0);
      expect(result.batteryCapacityKwh, 0);
    });

    test('accounts for peak load and usable battery capacity', () {
      final result = SolarCalculator.calculate(
        dailyKwh: 10,
        peakLoadKw: 4,
        city: cityById('tehran'),
      );

      expect(result.panelCount, 4);
      expect(result.arrayCapacityKw, 2.8);
      expect(result.inverterCapacityKw, 5);
      expect(result.batteryCapacityKwh, 13.9);
    });

    test('requires more panels in a lower-irradiance city', () {
      final rasht = SolarCalculator.calculate(
        dailyKwh: 12,
        city: cityById('rasht'),
      );
      final ahvaz = SolarCalculator.calculate(
        dailyKwh: 12,
        city: cityById('ahvaz'),
      );

      expect(rasht.panelCount, greaterThan(ahvaz.panelCount));
    });
  });
}
