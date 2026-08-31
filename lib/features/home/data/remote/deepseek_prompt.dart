import 'package:solar_calculator/features/solar/iran_solar_pricing.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';

/// Builds structured prompts for DeepSeek solar recommendations.
abstract final class DeepSeekPrompt {
  static String buildSystemMessage({
    required int usdToToman,
    String? rateDate,
  }) =>
      '''
You are a solar energy advisor for Iranian households.
Follow the response language explicitly requested in the user message.
Use markdown sections for solar panels, inverter, battery, and estimated cost.

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
    required SolarSizingResult solarSizing,
    required String languageCode,
  }) {
    final electricityLine = electricityRateToman != null
        ? '\n- نرخ برق خانگی: ${electricityRateToman.round()} تومان/kWh'
        : '';
    final rateLine = usdToToman != null
        ? '\n- نرخ دلار آزاد: $usdToToman تومان${rateDate != null ? ' ($rateDate)' : ''}'
        : '';
    final responseLanguage = languageCode == 'fa'
        ? 'Respond only in Persian (Farsi). Use these exact headings: ### پنل‌های خورشیدی, ### اینورتر, ### باتری, ### هزینه تقریبی.'
        : 'Respond only in English. Use these exact headings: ### Solar panels, ### Inverter, ### Battery, ### Estimated cost.';

    return '''
Analyze this household and recommend a suitable solar setup for Iran in 1405.
$responseLanguage

**Calculated consumption**
- روزانه: ${dailyKwh.toStringAsFixed(2)} kWh
- ماهانه: ${monthlyKwh.toStringAsFixed(1)} kWh
- سالانه: ${yearlyKwh.toStringAsFixed(0)} kWh

**Location & rates**
- شهر: $city$electricityLine$rateLine

**Authoritative local sizing baseline**
- پنل: ${solarSizing.panelCount} × ${SolarCalculator.defaultPanelWattage.round()}W (${solarSizing.arrayCapacityKw.toStringAsFixed(1)} kW)
- اینورتر: ${solarSizing.inverterCapacityKw.toStringAsFixed(1)} kW
- باتری نامی برای یک روز پشتیبانی: ${solarSizing.batteryCapacityKwh.toStringAsFixed(1)} kWh
- تابش استفاده‌شده: ${solarSizing.irradianceUsed.toStringAsFixed(1)} kWh/m²/day

**Appliance list (JSON)**
$appliancesJson

Calculate all costs in USD first (global price + Iran premium %), then convert to Toman.
Use 1405 models: Jinko Tiger Neo 5.0, LONGi Hi-MO 9, JA Solar DeepBlue 4.0 Pro, Trina Vertex S+.
Recommend on-grid unless consumption pattern suggests backup is needed.
Keep panel count, inverter capacity, and battery capacity consistent with the authoritative local sizing baseline above; explain rather than replace it.
In the estimated-cost section show: USD breakdown + Toman total + formula used.
''';
  }
}
