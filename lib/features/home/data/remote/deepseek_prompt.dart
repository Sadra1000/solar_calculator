import 'package:solar_calculator/features/solar/iran_solar_pricing.dart';

/// Builds structured prompts for DeepSeek solar recommendations.
abstract final class DeepSeekPrompt {
  static String buildSystemMessage({
    required int usdToToman,
    String? rateDate,
  }) => '''
You are a solar energy advisor for Iranian households.
Respond ONLY in Persian (Farsi).
Use the exact section headings below in markdown.

Required output sections (use these headings exactly):
### پنل‌های خورشیدی
### اینورتر
### باتری
### هزینه تقریبی

Be practical, concise, and use 1405 (2026) equipment models only.
Include specific panel count, inverter kW, battery kWh, and cost in BOTH USD and Toman.
Mention specific brands/models from the catalog below.
NEVER quote static Toman prices — always calculate: Iran_USD × $usdToToman = Toman.
Apply the Iran premium percentages to global USD prices before converting.

${IranSolarPricing.promptCatalog(usdToToman: usdToToman, rateDate: rateDate)}
''';

  static String buildUserMessage({
    required String appliancesJson,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    String city = 'تهران',
    double? electricityRateToman,
    int? usdToToman,
    String? rateDate,
  }) {
    final electricityLine =
        electricityRateToman != null
            ? '\n- نرخ برق خانگی: ${electricityRateToman.round()} تومان/kWh'
            : '';
    final rateLine =
        usdToToman != null
            ? '\n- نرخ دلار آزاد: $usdToToman تومان${rateDate != null ? ' ($rateDate)' : ''}'
            : '';

    return '''
Analyze this household and recommend a suitable solar setup for Iran in 1405.

**Calculated consumption**
- روزانه: ${dailyKwh.toStringAsFixed(2)} kWh
- ماهانه: ${monthlyKwh.toStringAsFixed(1)} kWh
- سالانه: ${yearlyKwh.toStringAsFixed(0)} kWh

**Location & rates**
- شهر: $city$electricityLine$rateLine

**Appliance list (JSON)**
$appliancesJson

Calculate all costs in USD first (global price + Iran premium %), then convert to Toman.
Use 1405 models: Jinko Tiger Neo 5.0, LONGi Hi-MO 9, JA Solar DeepBlue 4.0 Pro, Trina Vertex S+.
Recommend on-grid unless consumption pattern suggests backup is needed.
In ### هزینه تقریبی show: USD breakdown + Toman total + formula used.
''';
  }
}
