import 'dart:convert';

import 'package:solar_calculator/features/result/repository/model.dart';

class CalculationHistoryEntry {
  const CalculationHistoryEntry({
    required this.timestampMs,
    required this.dailyConsumption,
    required this.monthlyConsumption,
    required this.yearlyConsumption,
    required this.yearlyCo2Production,
    required this.applianceCount,
    required this.applianceSummary,
  });

  final int timestampMs;
  final double dailyConsumption;
  final double monthlyConsumption;
  final double yearlyConsumption;
  final double yearlyCo2Production;
  final int applianceCount;
  final String applianceSummary;

  factory CalculationHistoryEntry.fromResult(
    ResulteModel result, {
    required int applianceCount,
    required String applianceSummary,
  }) {
    return CalculationHistoryEntry(
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      dailyConsumption: result.dailyConsumption,
      monthlyConsumption: result.monthlyConsumption,
      yearlyConsumption: result.yearlyConsumption,
      yearlyCo2Production: result.yearlyCo2Production,
      applianceCount: applianceCount,
      applianceSummary: applianceSummary,
    );
  }

  factory CalculationHistoryEntry.fromJson(Map<String, dynamic> json) {
    return CalculationHistoryEntry(
      timestampMs: json['timestampMs'] as int,
      dailyConsumption: (json['dailyConsumption'] as num).toDouble(),
      monthlyConsumption: (json['monthlyConsumption'] as num).toDouble(),
      yearlyConsumption: (json['yearlyConsumption'] as num).toDouble(),
      yearlyCo2Production: (json['yearlyCo2Production'] as num).toDouble(),
      applianceCount: json['applianceCount'] as int,
      applianceSummary: json['applianceSummary'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestampMs': timestampMs,
    'dailyConsumption': dailyConsumption,
    'monthlyConsumption': monthlyConsumption,
    'yearlyConsumption': yearlyConsumption,
    'yearlyCo2Production': yearlyCo2Production,
    'applianceCount': applianceCount,
    'applianceSummary': applianceSummary,
  };

  static List<CalculationHistoryEntry> listFromJsonString(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CalculationHistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<CalculationHistoryEntry> entries) {
    return jsonEncode(entries.map((e) => e.toJson()).toList());
  }
}
