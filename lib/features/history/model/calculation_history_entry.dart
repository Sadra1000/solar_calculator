import 'dart:convert';

import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/result/model/result_session.dart';
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
    this.result,
    this.appliances,
    this.cityId,
    this.languageCode,
    this.electricityRateToman,
  });

  final int timestampMs;
  final double dailyConsumption;
  final double monthlyConsumption;
  final double yearlyConsumption;
  final double yearlyCo2Production;
  final int applianceCount;
  final String applianceSummary;

  /// Full snapshot for reopening ResultPage (null on legacy entries).
  final ResulteModel? result;
  final List<Appliance>? appliances;
  final String? cityId;
  final String? languageCode;
  final double? electricityRateToman;

  bool get canOpenResults =>
      result != null &&
      appliances != null &&
      cityId != null &&
      languageCode != null &&
      electricityRateToman != null;

  ResultSession? toResultSession() {
    if (!canOpenResults) return null;
    return ResultSession(
      result: result!,
      appliances: appliances!,
      cityId: cityId!,
      languageCode: languageCode!,
      requestAi: false,
      electricityRateToman: electricityRateToman!,
      persistHistory: false,
    );
  }

  factory CalculationHistoryEntry.fromResult(
    ResulteModel result, {
    required ResultSession session,
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
      result: result,
      appliances: List<Appliance>.from(session.appliances),
      cityId: session.cityId,
      languageCode: session.languageCode,
      electricityRateToman: session.electricityRateToman,
    );
  }

  factory CalculationHistoryEntry.fromJson(Map<String, dynamic> json) {
    final resultJson = json['result'] as Map<String, dynamic>?;
    final appliancesJson = json['appliances'] as List<dynamic>?;

    return CalculationHistoryEntry(
      timestampMs: json['timestampMs'] as int,
      dailyConsumption: (json['dailyConsumption'] as num).toDouble(),
      monthlyConsumption: (json['monthlyConsumption'] as num).toDouble(),
      yearlyConsumption: (json['yearlyConsumption'] as num).toDouble(),
      yearlyCo2Production: (json['yearlyCo2Production'] as num).toDouble(),
      applianceCount: json['applianceCount'] as int,
      applianceSummary: json['applianceSummary'] as String,
      result:
          resultJson != null ? ResulteModel.fromJson(resultJson) : null,
      appliances:
          appliancesJson
              ?.map(
                (e) => Appliance.fromStoredMap(e as Map<String, dynamic>),
              )
              .toList(),
      cityId: json['cityId'] as String?,
      languageCode: json['languageCode'] as String?,
      electricityRateToman:
          (json['electricityRateToman'] as num?)?.toDouble(),
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
    if (result != null) 'result': result!.toJson(),
    if (appliances != null)
      'appliances': appliances!.map((a) => a.toMap()).toList(),
    if (cityId != null) 'cityId': cityId,
    if (languageCode != null) 'languageCode': languageCode,
    if (electricityRateToman != null)
      'electricityRateToman': electricityRateToman,
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
