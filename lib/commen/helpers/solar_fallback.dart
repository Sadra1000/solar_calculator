import 'package:solar_calculator/commen/services/exchange_rate_service.dart';
import 'package:solar_calculator/features/solar/iran_solar_pricing.dart';
import 'package:solar_calculator/features/solar/solar_calculator.dart';

/// Formula-based solar recommendation when the AI API is unavailable.
abstract final class SolarFallback {
  static String buildRecommendation({
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    required SolarSizingResult solarSizing,
    required String languageCode,
    String city = 'تهران',
    String? budget,
    int usdToToman = ExchangeRateService.fallbackUsdToman,
    String? rateDate,
  }) {
    final panelW = SolarModels1405.defaultPanelWattage;
    final panelCount = solarSizing.panelCount;
    final actualKw = solarSizing.arrayCapacityKw;
    final inverterKw = solarSizing.inverterCapacityKw;
    final batteryKwh = solarSizing.batteryCapacityKwh;

    final totalUsd = IranSolarPricing.estimateSystemIranUsd(
      systemKw: actualKw,
      withBattery: false,
    );
    final totalToman = IranSolarPricing.toToman(totalUsd, usdToToman);
    final perWUsd = IranSolarPricing.installedOnGridIranUsdPerW();

    final budgetLine = budget != null && budget.isNotEmpty
        ? '\n**نرخ برق:** $budget'
        : '';

    final altPanels = SolarModels1405.alternatePanels.join('، ');
    final rateLabel = rateDate == null
        ? '$usdToToman تومان'
        : '$usdToToman تومان ($rateDate)';

    if (languageCode == 'en') {
      final englishRateLabel = rateDate == null
          ? '$usdToToman Toman'
          : '$usdToToman Toman ($rateDate)';
      final electricityLine = budget != null && budget.isNotEmpty
          ? '\n- Electricity rate: $budget'
          : '';
      return '''
## Local recommendation

> Planning scenario based on global USD pricing + a conservative Iran market-premium assumption (+${IranSolarPricing.totalEquipmentPremiumPct}%) × USD rate $englishRateLabel

**Inputs**
- City: $city
- Daily consumption: ${dailyKwh.toStringAsFixed(2)} kWh
- Monthly consumption: ${monthlyKwh.toStringAsFixed(1)} kWh
- Annual consumption: ${yearlyKwh.toStringAsFixed(0)} kWh
- USD rate: $englishRateLabel$electricityLine

---

### Solar panels
- Quantity: **$panelCount × $panelW W**
- Array capacity: **${actualKw.toStringAsFixed(1)} kW**
- Primary model: **${SolarModels1405.defaultPanelModel}**
- Alternatives: $altPanels

### Inverter
- Recommended standard capacity: **${inverterKw.toStringAsFixed(1)} kW**
- Model: **${SolarModels1405.defaultInverter}** or ${SolarModels1405.hybridInverters.first}

### Battery
- Nominal one-day backup capacity: **${batteryKwh.toStringAsFixed(1)} kWh**
- Optional for an on-grid setup
- Model family: ${SolarModels1405.defaultBattery}

### Estimated cost
- **~\$${totalUsd.toStringAsFixed(0)} USD** for an installed on-grid planning scenario
- **~${_formatToman(totalToman)} Toman** at $englishRateLabel
- Assumed Iran installed cost: ~\$${perWUsd.toStringAsFixed(2)}/W

---
*This is a preliminary estimate. Confirm equipment prices and site conditions with a qualified installer or electrical engineer.*
''';
    }

    return '''
## توصیه محلی (بدون هوش مصنوعی)

> سناریوی برنامه‌ریزی بر اساس قیمت جهانی USD + فرض حاشیه بازار ایران (+${IranSolarPricing.totalEquipmentPremiumPct}%) × نرخ دلار $rateLabel

**ورودی‌ها**
- شهر: $city
- مصرف روزانه: ${dailyKwh.toStringAsFixed(2)} کیلووات‌ساعت
- مصرف ماهانه: ${monthlyKwh.toStringAsFixed(1)} کیلووات‌ساعت
- مصرف سالانه: ${yearlyKwh.toStringAsFixed(0)} کیلووات‌ساعت
- نرخ دلار: $rateLabel$budgetLine

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
*این خروجی برآورد اولیه است. قیمت‌ها و شرایط نصب را با نصاب یا مهندس برق تأیید کنید.*
''';
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
