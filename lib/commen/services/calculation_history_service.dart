import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists calculation results for history screen (batch 5 integration).
class CalculationHistoryService {
  CalculationHistoryService(this._prefs);

  static const _key = 'calculation_history_v1';
  static const _maxEntries = 50;

  final SharedPreferences _prefs;

  Future<void> save({
    required double dailyKwh,
    required double yearlyKwh,
    required String analysis,
    required bool isFallback,
  }) async {
    final entries = await loadRaw();
    entries.insert(0, {
      'timestamp': DateTime.now().toIso8601String(),
      'dailyKwh': dailyKwh,
      'yearlyKwh': yearlyKwh,
      'analysis': analysis,
      'isFallback': isFallback,
    });
    if (entries.length > _maxEntries) {
      entries.removeRange(_maxEntries, entries.length);
    }
    await _prefs.setString(_key, jsonEncode(entries));
  }

  Future<List<Map<String, dynamic>>> loadRaw() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
