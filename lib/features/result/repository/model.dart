import 'package:solar_calculator/features/solar/solar_calculator.dart';

class ApplianceConsumptionShare {
  const ApplianceConsumptionShare({
    required this.name,
    required this.dailyKwh,
  });

  final String name;
  final double dailyKwh;

  Map<String, dynamic> toJson() => {
    'name': name,
    'dailyKwh': dailyKwh,
  };

  factory ApplianceConsumptionShare.fromJson(Map<String, dynamic> json) {
    return ApplianceConsumptionShare(
      name: json['name'] as String,
      dailyKwh: (json['dailyKwh'] as num).toDouble(),
    );
  }
}

class ResulteModel {
  final double dailyConsumption;
  final double monthlyConsumption;
  final double yearlyConsumption;
  final double yearlyCo2Production;
  final String analysis;
  final List<ApplianceConsumptionShare> applianceShares;
  final SolarSizingResult solarSizing;
  final double monthlyCostToman;
  final double yearlyCostToman;
  final double electricityRateToman;

  const ResulteModel({
    required this.analysis,
    required this.dailyConsumption,
    required this.monthlyConsumption,
    required this.yearlyConsumption,
    required this.yearlyCo2Production,
    required this.applianceShares,
    required this.solarSizing,
    required this.monthlyCostToman,
    required this.yearlyCostToman,
    required this.electricityRateToman,
  });

  ResulteModel copyWith({
    String? analysis,
    double? dailyConsumption,
    double? monthlyConsumption,
    double? yearlyConsumption,
    double? yearlyCo2Production,
    List<ApplianceConsumptionShare>? applianceShares,
    SolarSizingResult? solarSizing,
    double? monthlyCostToman,
    double? yearlyCostToman,
    double? electricityRateToman,
  }) {
    return ResulteModel(
      analysis: analysis ?? this.analysis,
      dailyConsumption: dailyConsumption ?? this.dailyConsumption,
      monthlyConsumption: monthlyConsumption ?? this.monthlyConsumption,
      yearlyConsumption: yearlyConsumption ?? this.yearlyConsumption,
      yearlyCo2Production: yearlyCo2Production ?? this.yearlyCo2Production,
      applianceShares: applianceShares ?? this.applianceShares,
      solarSizing: solarSizing ?? this.solarSizing,
      monthlyCostToman: monthlyCostToman ?? this.monthlyCostToman,
      yearlyCostToman: yearlyCostToman ?? this.yearlyCostToman,
      electricityRateToman: electricityRateToman ?? this.electricityRateToman,
    );
  }

  Map<String, dynamic> toJson() => {
    'analysis': analysis,
    'dailyConsumption': dailyConsumption,
    'monthlyConsumption': monthlyConsumption,
    'yearlyConsumption': yearlyConsumption,
    'yearlyCo2Production': yearlyCo2Production,
    'applianceShares': applianceShares.map((e) => e.toJson()).toList(),
    'solarSizing': solarSizing.toJson(),
    'monthlyCostToman': monthlyCostToman,
    'yearlyCostToman': yearlyCostToman,
    'electricityRateToman': electricityRateToman,
  };

  factory ResulteModel.fromJson(Map<String, dynamic> json) {
    return ResulteModel(
      analysis: json['analysis'] as String? ?? '',
      dailyConsumption: (json['dailyConsumption'] as num).toDouble(),
      monthlyConsumption: (json['monthlyConsumption'] as num).toDouble(),
      yearlyConsumption: (json['yearlyConsumption'] as num).toDouble(),
      yearlyCo2Production: (json['yearlyCo2Production'] as num).toDouble(),
      applianceShares:
          (json['applianceShares'] as List<dynamic>? ?? const [])
              .map(
                (e) => ApplianceConsumptionShare.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      solarSizing: SolarSizingResult.fromJson(
        json['solarSizing'] as Map<String, dynamic>,
      ),
      monthlyCostToman: (json['monthlyCostToman'] as num?)?.toDouble() ?? 0,
      yearlyCostToman: (json['yearlyCostToman'] as num?)?.toDouble() ?? 0,
      electricityRateToman:
          (json['electricityRateToman'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return '''
ResulteModel(
  Daily Consumption:   ${dailyConsumption.toStringAsFixed(2)} kWh
  Monthly Consumption: ${monthlyConsumption.toStringAsFixed(2)} kWh
  Yearly Consumption:  ${yearlyConsumption.toStringAsFixed(2)} kWh
  Yearly CO2 Production: ${yearlyCo2Production.toStringAsFixed(2)} kg
)''';
  }
}
