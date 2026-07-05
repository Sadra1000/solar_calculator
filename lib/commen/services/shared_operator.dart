import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_calculator/features/history/model/calculation_history_entry.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';

class SharedPrefOperator {
  static const maxHistoryEntries = 10;

  static const _keyOnboarding = 'user_visited_onboarding';
  static const _keySelectedAppliances = 'selected_appliances';
  static const _keySelectedCityId = 'selected_city_id';
  static const _keyElectricityRate = 'electricity_rate_toman';
  static const _keyCalculationHistory = 'calculation_history';
  static const _keyDarkMode = 'dark_mode';
  static const _keyLocaleCode = 'locale_code';

  final SharedPreferences sharedPreferences;

  SharedPrefOperator(this.sharedPreferences);

  Future<void> setUserVisitedOnboarding(bool hasVisited) async {
    await sharedPreferences.setBool(_keyOnboarding, hasVisited);
  }

  bool hasUserVisitedOnboarding() {
    return sharedPreferences.getBool(_keyOnboarding) ?? false;
  }

  Future<void> saveSelectedAppliances(List<Appliance> appliances) async {
    final json = jsonEncode(appliances.map((a) => a.toMap()).toList());
    await sharedPreferences.setString(_keySelectedAppliances, json);
  }

  List<Appliance> loadSelectedAppliances() {
    final raw = sharedPreferences.getString(_keySelectedAppliances);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (e) => Appliance.fromStoredMap(e as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSelectedCityId(String cityId) async {
    await sharedPreferences.setString(_keySelectedCityId, cityId);
  }

  String loadSelectedCityId() {
    return sharedPreferences.getString(_keySelectedCityId) ?? 'tehran';
  }

  Future<void> saveElectricityRate(double rate) async {
    await sharedPreferences.setDouble(_keyElectricityRate, rate);
  }

  double loadElectricityRate() {
    return sharedPreferences.getDouble(_keyElectricityRate) ?? 2500;
  }

  Future<void> addCalculationHistory(CalculationHistoryEntry entry) async {
    final history = loadCalculationHistory();
    history.insert(0, entry);
    if (history.length > maxHistoryEntries) {
      history.removeRange(maxHistoryEntries, history.length);
    }
    await sharedPreferences.setString(
      _keyCalculationHistory,
      CalculationHistoryEntry.listToJsonString(history),
    );
  }

  List<CalculationHistoryEntry> loadCalculationHistory() {
    final raw = sharedPreferences.getString(_keyCalculationHistory);
    if (raw == null || raw.isEmpty) return [];
    try {
      return CalculationHistoryEntry.listFromJsonString(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveDarkMode(bool isDark) async {
    await sharedPreferences.setBool(_keyDarkMode, isDark);
  }

  /// `false` = light, `true` = dark.
  bool loadDarkMode() {
    return sharedPreferences.getBool(_keyDarkMode) ?? true;
  }

  Future<void> saveLocaleCode(String code) async {
    await sharedPreferences.setString(_keyLocaleCode, code);
  }

  String loadLocaleCode() {
    return sharedPreferences.getString(_keyLocaleCode) ?? 'fa';
  }
}
