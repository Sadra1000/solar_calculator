import 'package:solar_calculator/features/solar/iran_cities.dart';

class SolarSizingResult {
  const SolarSizingResult({
    required this.panelCount,
    required this.arrayCapacityKw,
    required this.inverterCapacityKw,
    required this.batteryCapacityKwh,
    required this.irradianceUsed,
    required this.cityName,
  });

  final int panelCount;
  final double arrayCapacityKw;
  final double inverterCapacityKw;
  final double batteryCapacityKwh;
  final double irradianceUsed;
  final String cityName;
}

/// Formula-based solar system sizing from daily consumption.
class SolarCalculator {
  static const double defaultPanelWattage = 550;
  static const double systemPerformanceRatio = 0.78;
  static const double backupDays = 1.0;
  static const double inverterSafetyFactor = 1.15;

  static SolarSizingResult calculate({
    required double dailyKwh,
    required IranCity city,
    String? cityDisplayName,
  }) {
    final irradiance = city.irradianceKwhPerM2Day;
    final arrayKw =
        dailyKwh / (irradiance * systemPerformanceRatio);
    final panelCount =
        arrayKw <= 0
            ? 0
            : (arrayKw * 1000 / defaultPanelWattage).ceil();
    final actualArrayKw = panelCount * defaultPanelWattage / 1000;
    final inverterKw = (actualArrayKw * inverterSafetyFactor * 10).ceil() / 10;
    final batteryKwh = dailyKwh * backupDays;

    return SolarSizingResult(
      panelCount: panelCount,
      arrayCapacityKw: actualArrayKw,
      inverterCapacityKw: inverterKw,
      batteryCapacityKwh: batteryKwh,
      irradianceUsed: irradiance,
      cityName: cityDisplayName ?? city.nameFa,
    );
  }
}
