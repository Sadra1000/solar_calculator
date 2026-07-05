/// Formula-based solar recommendation when the AI API is unavailable.
abstract final class SolarFallback {
  static const double peakSunHoursIran = 4.5;
  static const int panelWattage = 550;
  static const int panelCostUsdApprox = 180;

  static String buildRecommendation({
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    String city = 'تهران',
    String? budget,
  }) {
    final systemKw =
        (dailyKwh / peakSunHoursIran).clamp(0.5, double.infinity);
    final panelCount = (systemKw * 1000 / panelWattage).ceil().clamp(1, 999);
    final actualKw = panelCount * panelWattage / 1000;
    final inverterKw = _roundInverterSize(actualKw);
    final batteryKwh = (dailyKwh * 0.5).ceil().clamp(1, 100);
    final estimatedCost = panelCount * panelCostUsdApprox * 42000;

    final budgetLine =
        budget != null && budget.isNotEmpty
            ? '\n**بودجه درخواستی:** $budget'
            : '';

    return '''
## توصیه محلی (بدون هوش مصنوعی)

> این پیشنهاد بر اساس مصرف محاسبه‌شده و فرمول استاندارد خورشیدی تهیه شده است.

**ورودی‌ها**
- شهر: $city
- مصرف روزانه: ${dailyKwh.toStringAsFixed(2)} کیلووات‌ساعت
- مصرف ماهانه: ${monthlyKwh.toStringAsFixed(1)} کیلووات‌ساعت
- مصرف سالانه: ${yearlyKwh.toStringAsFixed(0)} کیلووات‌ساعت$budgetLine

---

### پنل‌های خورشیدی
- تعداد پنل پیشنهادی: **$panelCount عدد** ($panelWattage وات)
- ظرفیت کل: **${actualKw.toStringAsFixed(1)} کیلووات**
- با $peakSunHoursIran ساعت اوج تابش در $city

### اینورتر
- ظرفیت پیشنهادی: **$inverterKw کیلووات**
- نوع: اینورتر رشته‌ای (String) با ردیاب نقطه حداکثر توان (MPPT)

### باتری
- ظرفیت پیشنهادی: **$batteryKwh کیلووات‌ساعت**
- برای پوشش حدود ۵۰٪ مصرف شبانه (اختیاری برای شبکه‌متصل)

### هزینه تقریبی
- برآورد اولیه نصب: **~${ _formatToman(estimatedCost)} تومان**
- شامل پنل، اینورتر، سازه و نصب (بدون باتری)

---
*برای دقت بیشتر با یک نصاب محلی مشورت کنید.*
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
