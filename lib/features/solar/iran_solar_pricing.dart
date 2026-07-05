/// Iran solar market pricing: USD base + premium %, converted via live rate.
///
/// Premium covers sanctions routing, limited official imports, and distribution markup.
abstract final class IranSolarPricing {
  // --- Iran premium components (percent added to international USD price) ---
  static const int sanctionsImportPct = 45;
  static const int limitedOfficialImportPct = 20;
  static const int distributionMarkupPct = 28;

  /// Combined equipment premium (~93 % on top of global USD).
  static int get totalEquipmentPremiumPct =>
      sanctionsImportPct + limitedOfficialImportPct + distributionMarkupPct;

  static double iranUsdFromGlobal(double globalUsd, {int? premiumPct}) {
    final pct = premiumPct ?? totalEquipmentPremiumPct;
    return globalUsd * (1 + pct / 100);
  }

  static int toToman(double usd, int usdToToman) => (usd * usdToToman).round();

  // --- Global USD reference prices (2025–2026, ex-factory / international retail) ---
  static const double panelModuleUsdPerW = 0.14;
  static const double installedSoftCostUsdPerW = 0.55;
  static const double inverterOnGridUsdPerKw = 180;
  static const double inverterHybridUsdPerKw = 260;
  static const double batteryLiFePO4UsdPerKwh = 190;
  static const double structureCablingUsdPerKw = 90;

  /// Installed on-grid system (global benchmark, USD/W before Iran premium).
  static const double installedOnGridGlobalUsdPerW = 0.85;

  /// Installed hybrid (+ battery BOS) global benchmark, USD/W before premium.
  static const double installedHybridGlobalUsdPerW = 1.15;

  static double installedOnGridIranUsdPerW({int? premiumPct}) =>
      iranUsdFromGlobal(installedOnGridGlobalUsdPerW, premiumPct: premiumPct);

  static double estimateSystemIranUsd({
    required double systemKw,
    bool withBattery = false,
    double batteryKwh = 0,
    int? premiumPct,
  }) {
    final pct = premiumPct ?? totalEquipmentPremiumPct;
    final basePerW =
        withBattery ? installedHybridGlobalUsdPerW : installedOnGridGlobalUsdPerW;
    var total = iranUsdFromGlobal(systemKw * 1000 * basePerW, premiumPct: pct);
    if (batteryKwh > 0) {
      total += iranUsdFromGlobal(
        batteryKwh * batteryLiFePO4UsdPerKwh,
        premiumPct: pct + 30,
      );
    }
    return total;
  }

  /// Markdown block for AI system prompt.
  static String promptCatalog({required int usdToToman, String? rateDate}) {
    final rateLine =
        rateDate != null
            ? 'نرخ دلار آزاد: **$usdToToman تومان** (تاریخ: $rateDate)'
            : 'نرخ دلار آزاد: **$usdToToman تومان**';

    return '''
**روش قیمت‌گذاری (الزامی — قیمت ثابت تومانی ندهید)**

$rateLine

همه قیمت‌ها را ابتدا به **دلار (USD)** محاسبه کنید، سپس:
`قیمت تومان = قیمت دلار ایران × $usdToToman`

**حاشیه بازار ایران (روی قیمت جهانی USD):**
| عامل | درصد | توضیح |
|------|------|-------|
| تحریم و مسیر غیررسمی واردات | +$sanctionsImportPct% | روتینگ غیرمستقیم، بیمه، تأخیر |
| واردات محدود / گلوگاه رسمی | +$limitedOfficialImportPct% | عرضه کم، تقاضای بالا |
| حاشیه توزیع (واسطه‌ها) | +$distributionMarkupPct% | مارکتپلیس، نصاب، عمده‌فروش |
| **جمع حاشیه تجهیزات** | **+$totalEquipmentPremiumPct%** | روی قیمت جهانی USD |
| باتری (اضافه) | +۳۰% بیشتر | تحریم سنگین‌تر روی سلول |

فرمول: `قیمت_ایران_USD = قیمت_جهانی_USD × (1 + حاشیه%/100)`

---

**مدل‌های پیشنهادی ۱۴۰۵ (۲۰۲۶) — فقط این نسل‌ها**

**پنل (N-Type TOPCon / HPBC):**
| مدل | توان | راندمان | قیمت جهانی (USD) |
|-----|------|---------|------------------|
| Jinko Tiger Neo 5.0 (JKM700N-66HL4) | 700W | 25.9% | ~\$98/پنل (\$$panelModuleUsdPerW/W) |
| Jinko Tiger Neo 3.0 (JKM620N-66HL4) | 620–670W | 23.2% | ~\$87–94/پنل |
| LONGi Hi-MO 9 (HPBC 2.0) | 650–720W | 24.8% | ~\$95–105/پنل |
| JA Solar DeepBlue 4.0 Pro (JAM72D42) | 620–645W | 23.0% | ~\$87–90/پنل |
| Trina Vertex S+ TSM-NEG21C.20 | 710–715W | 23.1% | ~\$100–102/پنل |
| Canadian Solar HiKu7 CS7N-645MS | 645W | 23.0% | ~\$90/پنل |

**اینورتر (تک‌فاز / هیبرید):**
| مدل | ظرفیت | قیمت جهانی (USD) |
|-----|-------|------------------|
| Huawei SUN2000-5KTL-L1 (hybrid) | 5 kW | ~\$800–950 |
| Growatt MIN 5000TL-XH (hybrid) | 5 kW | ~\$750–900 |
| Sungrow SH5.0RS (hybrid) | 5 kW | ~\$850–1000 |
| Growatt SPF 6000 ES Plus (off-grid/hybrid) | 6 kW | ~\$1100–1400 |
| Huawei SUN2000-10KTL-M1 (سه‌فاز) | 10 kW | ~\$1400–1800 |
| Solis S6-GR1P5K (on-grid) | 5 kW | ~\$550–700 |

**باتری LiFePO4:**
| مدل | ظرفیت | قیمت جهانی (USD) |
|-----|-------|------------------|
| Huawei LUNA2000-5-S0 | 5 kWh | ~\$890–1200 |
| Growatt Hope 5.0L-B1 | 5.12 kWh | ~\$630–900 |
| BYD Battery-Box Premium HVS 5.1 | 5.1 kWh | ~\$800–1100 |
| Pylontech US5000 | 4.8 kWh | ~\$700–950 |
| Growatt Hope 10.0L | 10 kWh | ~\$1200–1600 |

**نصب و BOS (جهانی، قبل از حاشیه ایران):**
| آیتم | USD |
|------|-----|
| سازه + کابل + تابلو (هر kW) | ~\$$structureCablingUsdPerKw/kW |
| نصب و راه‌اندازی (هر kW) | ~\$$installedSoftCostUsdPerW/W کل سیستم |
| سیستم on-grid نصب‌شده (کل) | ~\$$installedOnGridGlobalUsdPerW/W |
| سیستم hybrid نصب‌شده (کل) | ~\$$installedHybridGlobalUsdPerW/W |

---

**قوانین محاسبه (اجباری)**
1. قیمت هر بخش = قیمت جهانی USD × (1 + $totalEquipmentPremiumPct%)؛ باتری: +۳۰% اضافه.
2. هزینه کل USD را محاسبه کنید، سپس × $usdToToman = تومان.
3. در خروجی **هر دو** USD و تومان را بنویسید (مثال: ~\$4,500 / ~${_formatExampleToman(4500, usdToToman)} تومان).
4. پنل پیشنهادی: ۶۲۰–۷۲۰W از مدل‌های جدول بالا (اولویت: Tiger Neo 5.0، Hi-MO 9، DeepBlue 4.0 Pro).
5. ساعت اوج تابش ایران: ۴–۵.۵ ساعت؛ PR = ۰.۷۵–۰.۸۰.
6. PERC و پنل‌های زیر ۵۵۰W منسوخ — پیشنهاد نکنید.
7. قیمت‌های ۱۴۰۲–۱۴۰۳ یا نرخ دلار زیر ۱۰۰ هزار تومان منسوخ‌اند.
8. هرگز قیمت کل را فقط به تومان ثابت بدهید — همیشه از فرمول USD × نرخ دلار استفاده کنید.
''';
  }

  static String _formatExampleToman(double usd, int rate) {
    final t = (usd * rate).round();
    final s = t.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

/// Recommended panel models for 1405 (display / fallback).
abstract final class SolarModels1405 {
  static const defaultPanelWattage = 700;
  static const defaultPanelModel = 'Jinko Tiger Neo 5.0 (700W TOPCon)';
  static const alternatePanels = [
    'LONGi Hi-MO 9 HPBC (720W)',
    'JA Solar DeepBlue 4.0 Pro (645W)',
    'Trina Vertex S+ (715W)',
  ];
  static const defaultInverter = 'Huawei SUN2000-5KTL-L1';
  static const hybridInverters = [
    'Growatt MIN 5000TL-XH',
    'Sungrow SH5.0RS',
    'Growatt SPF 6000 ES Plus',
  ];
  static const defaultBattery = 'Growatt Hope 5.0L-B1 / Huawei LUNA2000-5-S0';
}
