/// Builds structured prompts for DeepSeek solar recommendations.
abstract final class DeepSeekPrompt {
  static const systemMessage = '''
You are a solar energy advisor for Iranian households.
Respond ONLY in Persian (Farsi).
Use the exact section headings below in markdown.

Required output sections (use these headings exactly):
### پنل‌های خورشیدی
### اینورتر
### باتری
### هزینه تقریبی

Be practical, concise, and use realistic numbers for Iran.
Include specific panel count, inverter kW, battery kWh, and cost estimate in each section.
''';

  static String buildUserMessage({
    required String appliancesJson,
    required double dailyKwh,
    required double monthlyKwh,
    required double yearlyKwh,
    String city = 'تهران',
    String? budget,
  }) {
    final budgetLine =
        budget != null && budget.isNotEmpty
            ? '\n- بودجه: $budget'
            : '';

    return '''
Analyze this household and recommend a suitable solar setup.

**Calculated consumption**
- روزانه: ${dailyKwh.toStringAsFixed(2)} kWh
- ماهانه: ${monthlyKwh.toStringAsFixed(1)} kWh
- سالانه: ${yearlyKwh.toStringAsFixed(0)} kWh

**Location & budget**
- شهر: $city$budgetLine

**Appliance list (JSON)**
$appliancesJson
''';
  }
}
