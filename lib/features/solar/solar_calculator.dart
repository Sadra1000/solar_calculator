import 'dart:math';

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

  Map<String, dynamic> toJson() => {
    'panelCount': panelCount,
    'arrayCapacityKw': arrayCapacityKw,
    'inverterCapacityKw': inverterCapacityKw,
    'batteryCapacityKwh': batteryCapacityKwh,
    'irradianceUsed': irradianceUsed,
    'cityName': cityName,
  };

  factory SolarSizingResult.fromJson(Map<String, dynamic> json) {
    return SolarSizingResult(
      panelCount: json['panelCount'] as int,
      arrayCapacityKw: (json['arrayCapacityKw'] as num).toDouble(),
      inverterCapacityKw: (json['inverterCapacityKw'] as num).toDouble(),
      batteryCapacityKwh: (json['batteryCapacityKwh'] as num).toDouble(),
      irradianceUsed: (json['irradianceUsed'] as num).toDouble(),
      cityName: json['cityName'] as String,
    );
  }
}

/// Formula-based solar system sizing from daily consumption.
class SolarCalculator {
  static const double defaultPanelWattage = 700;
  static const double systemPerformanceRatio = 0.78;
  static const double backupDays = 1.0;
  static const double inverterSafetyFactor = 1.15;
  static const double batteryDepthOfDischarge = 0.80;
  static const double batterySystemEfficiency = 0.90;
  static const List<double> standardInverterSizesKw = [
    1,
    1.5,
    2,
    3,
    5,
    6,
    8,
    10,
    12,
    15,
    20,
  ];

  static SolarSizingResult calculate({
    required double dailyKwh,
    required IranCity city,
    double peakLoadKw = 0,
    String? cityDisplayName,
  }) {
    final irradiance = city.irradianceKwhPerM2Day;
    final arrayKw = dailyKwh / (irradiance * systemPerformanceRatio);
    final panelCount = arrayKw <= 0
        ? 0
        : (arrayKw * 1000 / defaultPanelWattage).ceil();
    final actualArrayKw = panelCount * defaultPanelWattage / 1000;
    final inverterKw = _nextInverterSize(
      max(actualArrayKw, peakLoadKw) * inverterSafetyFactor,
    );
    final usableBatteryKwh = dailyKwh * backupDays;
    final batteryKwh = usableBatteryKwh <= 0
        ? 0.0
        : (usableBatteryKwh /
                      (batteryDepthOfDischarge * batterySystemEfficiency) *
                      10)
                  .ceil() /
              10;

    return SolarSizingResult(
      panelCount: panelCount,
      arrayCapacityKw: actualArrayKw,
      inverterCapacityKw: inverterKw,
      batteryCapacityKwh: batteryKwh,
      irradianceUsed: irradiance,
      cityName: cityDisplayName ?? city.nameFa,
    );
  }

  static double _nextInverterSize(double requiredKw) {
    if (requiredKw <= 0) return 0;
    for (final size in standardInverterSizesKw) {
      if (requiredKw <= size) return size;
    }
    return (requiredKw / 5).ceil() * 5.0;
  }
}
