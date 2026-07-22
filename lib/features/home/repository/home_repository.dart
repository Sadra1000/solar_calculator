// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:solar_calculator/commen/data_state.dart';
import 'package:solar_calculator/commen/error_handler/check_exceptions.dart';
import 'package:solar_calculator/commen/helpers/api_errors.dart';
import 'package:solar_calculator/commen/helpers/solar_fallback.dart';
import 'package:solar_calculator/commen/services/exchange_rate_service.dart';
import 'package:solar_calculator/features/home/data/appliance_catalog.dart';
import 'package:solar_calculator/features/home/data/remote/deepseek_prompt.dart';
import 'package:solar_calculator/features/home/data/remote/home_api.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/model/preset_profiles.dart';
import 'package:solar_calculator/features/result/repository/model.dart';
import 'package:solar_calculator/features/solar/iran_cities.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';

class HomeRepository {
  final HomeApi api;

  HomeRepository({required this.api});

  DataState<List<AppliancesCategory>> getAppliances() {
    return DataSuccess(List<AppliancesCategory>.from(applianceCatalog));
  }

  Map<String, dynamic> calculateConsumption(List<Appliance> appliances) {
    const int daysInYear = 365;
    const int monthsInYear = 12;
    const double kgCo2PerKwh = 0.417;

    double totalDailyKwh = 0.0;
    for (final appliance in appliances) {
      final dailyKwh = (appliance.powerUsage / 1000.0) * appliance.houres;
      totalDailyKwh += dailyKwh;
    }

    final double yearlyKwh = totalDailyKwh * daysInYear;
    final double monthlyKwh = yearlyKwh / monthsInYear;
    final double yearlyCo2 = yearlyKwh * kgCo2PerKwh;

    return {
      'dailyConsumption': totalDailyKwh,
      'monthlyConsumption': monthlyKwh,
      'yearlyConsumption': yearlyKwh,
      'yearlyCo2Production': yearlyCo2,
    };
  }

  List<ApplianceConsumptionShare> computeApplianceShares(
    List<Appliance> appliances, {
    required String languageCode,
  }) {
    final totals = <String, double>{};
    final labels = <String, String>{};
    for (final appliance in appliances) {
      final dailyKwh = (appliance.powerUsage / 1000.0) * appliance.houres;
      totals[appliance.id] = (totals[appliance.id] ?? 0) + dailyKwh;
      labels[appliance.id] = appliance.localizedName(languageCode);
    }
    return totals.entries
        .map(
          (e) => ApplianceConsumptionShare(
            name: labels[e.key]!,
            dailyKwh: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.dailyKwh.compareTo(a.dailyKwh));
  }

  Appliance? findApplianceById(String id) => applianceById[id];

  List<Appliance> resolvePresetAppliances(PresetProfile preset) {
    final resolved = <Appliance>[];
    for (final ref in preset.appliances) {
      final base = findApplianceById(ref.id);
      if (base != null) {
        resolved.add(base.copyWith(houres: ref.hours ?? base.houres));
      }
    }
    return resolved;
  }

  ResulteModel buildResultModel({
    required List<Appliance> appliances,
    required String cityId,
    required double electricityRateToman,
    required String languageCode,
    String analysis = '',
  }) {
    final map = calculateConsumption(appliances);
    final daily = map['dailyConsumption'] as double;
    final monthly = map['monthlyConsumption'] as double;
    final yearly = map['yearlyConsumption'] as double;
    final co2 = map['yearlyCo2Production'] as double;
    final city = cityById(cityId);
    final solar = SolarCalculator.calculate(
      dailyKwh: daily,
      city: city,
      cityDisplayName: city.localizedName(languageCode),
    );

    return ResulteModel(
      analysis: analysis,
      dailyConsumption: daily,
      monthlyConsumption: monthly,
      yearlyConsumption: yearly,
      yearlyCo2Production: co2,
      applianceShares: computeApplianceShares(
        appliances,
        languageCode: languageCode,
      ),
      solarSizing: solar,
      monthlyCostToman: monthly * electricityRateToman,
      yearlyCostToman: yearly * electricityRateToman,
      electricityRateToman: electricityRateToman,
    );
  }

  Future<String> buildUserPrompt({
    required List<Appliance> appliances,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    required String cityDisplayName,
    required double electricityRateToman,
    required String languageCode,
  }) async {
    final rate = await ExchangeRateService.fetchUsdToToman();
    return DeepSeekPrompt.buildUserMessage(
      appliancesJson: jsonEncode(
        _sortAppliances(appliances, languageCode: languageCode),
      ),
      dailyKwh: dailyKwh,
      monthlyKwh: monthlyKwh,
      yearlyKwh: yearlyKwh,
      city: cityDisplayName,
      electricityRateToman: electricityRateToman,
      usdToToman: rate.toman,
      rateDate: rate.sourceDate,
    );
  }

  Future<String> buildFallbackAnalysis({
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    required String cityDisplayName,
    double? electricityRateToman,
  }) async {
    final rate = await ExchangeRateService.fetchUsdToToman();
    final electricityLine =
        electricityRateToman != null
            ? '${electricityRateToman.round()} تومان/kWh'
            : null;
    return SolarFallback.buildRecommendation(
      dailyKwh: dailyKwh,
      monthlyKwh: monthlyKwh,
      yearlyKwh: yearlyKwh,
      city: cityDisplayName,
      budget: electricityLine,
      usdToToman: rate.toman,
    );
  }

  Future<DataState<String>> callDeepSeek({
    required List<Appliance> appliances,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    required String cityDisplayName,
    required double electricityRateToman,
    required String languageCode,
  }) async {
    try {
      final rate = await ExchangeRateService.fetchUsdToToman();
      final prompt = await buildUserPrompt(
        appliances: appliances,
        dailyKwh: dailyKwh,
        monthlyKwh: monthlyKwh,
        yearlyKwh: yearlyKwh,
        cityDisplayName: cityDisplayName,
        electricityRateToman: electricityRateToman,
        languageCode: languageCode,
      );
      final res = await api.callDeepSeekApi(
        prompt,
        usdToToman: rate.toman,
        rateDate: rate.sourceDate,
      );
      final data = res.data as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        return const DataFailed(ApiErrorKeys.generic);
      }
      final content =
          (choices.first as Map<String, dynamic>)['message']?['content']
              as String?;
      if (content == null || content.isEmpty) {
        return const DataFailed(ApiErrorKeys.generic);
      }
      return DataSuccess(content);
    } catch (e) {
      final errorState = await CheckExceptions.getError(e);
      return DataFailed(errorState.message ?? ApiErrorKeys.generic);
    }
  }

  Stream<String> streamDeepSeek({
    required List<Appliance> appliances,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    required String cityDisplayName,
    required double electricityRateToman,
    required String languageCode,
  }) async* {
    final rate = await ExchangeRateService.fetchUsdToToman();
    final prompt = await buildUserPrompt(
      appliances: appliances,
      dailyKwh: dailyKwh,
      monthlyKwh: monthlyKwh,
      yearlyKwh: yearlyKwh,
      cityDisplayName: cityDisplayName,
      electricityRateToman: electricityRateToman,
      languageCode: languageCode,
    );
    yield* api.streamDeepSeekApi(
      prompt,
      usdToToman: rate.toman,
      rateDate: rate.sourceDate,
    );
  }

  List<Map<String, dynamic>> _sortAppliances(
    List<Appliance> list, {
    required String languageCode,
  }) {
    final sortedList = <Map<String, dynamic>>[];
    for (final appliance in list) {
      final name = appliance.localizedName(languageCode);
      final existing = sortedList.where((e) => e['name'] == name);
      if (existing.isNotEmpty) {
        existing.first['count'] = (existing.first['count'] as int) + 1;
      } else {
        sortedList.add({
          'name': name,
          'consumption': appliance.powerUsage,
          'count': 1,
          'hours': appliance.houres,
        });
      }
    }
    return sortedList;
  }
}
