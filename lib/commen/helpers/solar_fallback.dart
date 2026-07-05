import 'package:solar_calculator/commen/services/exchange_rate_service.dart';
import 'package:solar_calculator/features/solar/iran_solar_pricing.dart';

/// Formula-based solar recommendation when the AI API is unavailable.
abstract final class SolarFallback {
  static const double peakSunHoursIran = 4.5;

  static String buildRecommendation({
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    String city = 'تهران',
    String? budget,
    int usdToToman = ExchangeRateService.fallbackUsdToman,
  }) {
    final panelW = SolarModels1405.defaultPanelWattage;
    final systemKw =
        (dailyKwh / peakSunHoursIran).clamp(0.5, double.infinity);
    final panelCount = (systemKw * 1000 / panelW).ceil().clamp(1, 999);
    final actualKw = panelCount * panelW / 1000;
    final inverterKw = _roundInverterSize(actualKw);
    final batteryKwh = (dailyKwh * 0.5).ceil().clamp(1, 100);

    final totalUsd = IranSolarPricing.estimateSystemIranUsd(
      systemKw: actualKw,
      withBattery: false,
    );
    final totalToman = IranSolarPricing.toToman(totalUsd, usdToToman);
    final perWUsd = IranSolarPricing.installedOnGridIranUsdPerW();

    final budgetLine =
        budget != null && budget.isNotEmpty
            ? '\n**نرخ برق:** $budget'
            : '';

    final altPanels = SolarModels1405.alternatePanels.join('، ');

    return '''
## توصیه محلی (بدون هوش مصنوعی)

> برآورد بر اساس قیمت جهانی USD + حاشیه ایران (+${IranSolarPricing.totalEquipmentPremiumPct}%) × نرخ دلار $usdToToman تومان

**ورودی‌ها**
- شهر: $city
- مصرف روزانه: ${dailyKwh.toStringAsFixed(2)} کیلووات‌ساعت
- مصرف ماهانه: ${monthlyKwh.toStringAsFixed(1)} کیلووات‌ساعت
- مصرف سالانه: ${yearlyKwh.toStringAsFixed(0)} کیلووات‌ساعت
- نرخ دلار: $usdToToman تومان$budgetLine

---

### پنل‌های خورشیدی
- تعداد: **$panelCount عدد** × $panelW وات
- ظرفیت: **${actualKw.toStringAsFixed(1)} kW**
- مدل اصلی: **${SolarModels1405.defaultPanelModel}**
- جایگزین: $altPanels
- قیمت جهانی پنل: ~\$${(panelCount * panelW * IranSolarPricing.panelModuleUsdPerW).toStringAsFixed(0)} (+${IranSolarPricing.totalEquipmentPremiumPct}% ایران)

### اینورتر
- ظرفیت: **$inverterKw kW**
- مدل: **${SolarModels1405.defaultInverter}** یا ${SolarModels1405.hybridInverters.first}
- قیمت جهانی: ~\$${(inverterKw * IranSolarPricing.inverterHybridUsdPerKw).toStringAsFixed(0)} (+${IranSolarPricing.totalEquipmentPremiumPct}% ایران)

### باتری
- ظرفیت پیشنهادی: **$batteryKwh kWh** (اختیاری برای on-grid)
- مدل: ${SolarModels1405.defaultBattery}
- قیمت جهانی: ~\$${(batteryKwh * IranSolarPricing.batteryLiFePO4UsdPerKwh).toStringAsFixed(0)} (+${IranSolarPricing.totalEquipmentPremiumPct + 30}% ایران)

### هزینه تقریبی
- **~\$${totalUsd.toStringAsFixed(0)} USD** (نصب on-grid، ~\$${perWUsd.toStringAsFixed(2)}/W با حاشیه ایران)
- **~${_formatToman(totalToman)} تومان** ($usdToToman تومان/دلار)
- فرمول: \$${IranSolarPricing.installedOnGridGlobalUsdPerW}/W جهانی × ${1 + IranSolarPricing.totalEquipmentPremiumPct / 100} × ${actualKw.toStringAsFixed(1)} kW × $usdToToman

---
*قیمت‌ها تقریبی‌اند. با نصاب محلی مشورت کنید.*
''';
  }

  static double _roundInverterSize(double kw) {
    const sizes = [3.0, 5.0, 6.0, 8.0, 10.0, 12.0, 15.0, 20.0];
    for (final size in sizes) {
      if (kw <= size) return size;
    }
    return (kw / 5).ceil() * 5.0;
  }

  static String _formatToman(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
