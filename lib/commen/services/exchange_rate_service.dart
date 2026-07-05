import 'package:dio/dio.dart';

/// Fetches free-market USD→Toman rate for solar cost estimates.
///
/// Source: https://github.com/rate-json/default (updated 3–4× daily).
abstract final class ExchangeRateService {
  static const int fallbackUsdToman = 175000;
  static const _url =
      'https://raw.githubusercontent.com/rate-json/default/main/data.json';
  static const _cacheDuration = Duration(hours: 6);

  static int? _cachedRate;
  static DateTime? _cachedAt;
  static String? _cachedDate;

  /// Returns USD sell price in Toman. Uses cache; falls back on network error.
  static Future<UsdRate> fetchUsdToToman({Dio? dio}) async {
    if (_cachedRate != null &&
        _cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < _cacheDuration) {
      return UsdRate(
        toman: _cachedRate!,
        sourceDate: _cachedDate,
        fromCache: true,
      );
    }

    try {
      final client = dio ?? Dio();
      final response = await client.get<dynamic>(
        _url,
        options: Options(receiveTimeout: const Duration(seconds: 12)),
      );
      final root = response.data;
      if (root is Map<String, dynamic>) {
        final values = root['values'];
        final usd = values is Map ? values['USD'] : null;
        if (usd is int && usd > 0) {
          _cachedRate = usd;
          _cachedAt = DateTime.now();
          _cachedDate = root['generated_by_tomanify_at'] as String?;
          return UsdRate(
            toman: usd,
            sourceDate: _cachedDate,
            fromCache: false,
          );
        }
      }
    } catch (_) {}

    return UsdRate(
      toman: _cachedRate ?? fallbackUsdToman,
      sourceDate: _cachedDate,
      fromCache: _cachedRate != null,
    );
  }

  /// Pre-warm cache during app startup (non-blocking).
  static Future<void> warmCache() => fetchUsdToToman();
}

class UsdRate {
  const UsdRate({
    required this.toman,
    this.sourceDate,
    this.fromCache = false,
  });

  final int toman;
  final String? sourceDate;
  final bool fromCache;
}
