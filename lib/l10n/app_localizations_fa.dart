// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'ماشین حساب خورشیدی';

  @override
  String get noItemsSelected => 'هیچ آیتمی انتخاب نشده است';

  @override
  String get calculate => 'حساب کن!';

  @override
  String get resultsTitle => 'نتایج محاسبه';

  @override
  String get dailyConsumption => 'مصرف روزانه:';

  @override
  String get monthlyConsumption => 'مصرف ماهانه:';

  @override
  String get yearlyConsumption => 'مصرف سالانه:';

  @override
  String get yearlyCo2Production => 'تولید CO2 سالانه:';

  @override
  String totalPower(String power) {
    return 'توان کل: $power';
  }

  @override
  String get addOne => 'افزودن یکی';

  @override
  String get removeOne => 'کم کردن یکی';

  @override
  String get removeAll => 'حذف کامل';

  @override
  String selectFromCategory(String category) {
    return 'انتخاب از دسته‌ی $category';
  }

  @override
  String watts(int power) {
    return '$power وات';
  }

  @override
  String get addNewAppliance => 'افزودن وسیله جدید';

  @override
  String get featureNotImplemented => 'این قابلیت هنوز پیاده‌سازی نشده است.';

  @override
  String get cancel => 'انصراف';

  @override
  String operatingHours(String name) {
    return 'ساعات کارکرد $name';
  }

  @override
  String get hoursPrompt =>
      'لطفا مشخص کنید این وسیله چند ساعت در شبانه‌روز روشن است.';

  @override
  String hoursValue(String hours) {
    return '$hours ساعت';
  }

  @override
  String get dismiss => 'لغو';

  @override
  String get confirm => 'تایید';

  @override
  String get rateLimitError =>
      'شما نمیتوانید بیش از 4 بار در روز از این سرویس استفاده کنید';

  @override
  String get notFound => 'یافت نشد';

  @override
  String get authError => 'مشکلی پیش اومده، لطفا با پشتیبانی در ارتباط باشید.';

  @override
  String get serverError => 'سرور پاسخگو نیست.';

  @override
  String get connectionError => 'اتصال به اینترنت دستگاه را بررسی کنید.';

  @override
  String get noInternet => 'لطفا از اتصال به اینترنت اطمینان حاصل کنید.';

  @override
  String get genericError => 'خطای غیرمنتظره‌ای رخ داد.';

  @override
  String get close => 'بستن';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get selectAppliancesToCalculate =>
      'برای محاسبه، حداقل یک وسیله انتخاب کنید.';

  @override
  String liveDailyConsumption(String value) {
    return 'مصرف روزانه تخمینی: $value';
  }

  @override
  String get deepSeekApiKeyMissing =>
      'کلید API هوش مصنوعی (DEEPSEEK_API_KEY) تنظیم نشده است. برای تحلیل هوشمند، کلید را در فایل .env قرار دهید.';

  @override
  String get analysisNotAvailable =>
      'تحلیل هوش مصنوعی در دسترس نیست. نتایج محاسبه محلی در زیر نمایش داده شده‌اند.';

  @override
  String get enableAiAnalysis => 'تحلیل هوشمند خورشیدی (DeepSeek)';

  @override
  String get presetsTitle => 'پیش‌فرض‌های سریع';

  @override
  String get editHours => 'ویرایش ساعات';

  @override
  String get applianceName => 'نام وسیله';

  @override
  String get powerWatts => 'توان (وات)';

  @override
  String get selectCity => 'شهر';

  @override
  String get electricityRate => 'نرخ برق (تومان/kWh)';

  @override
  String get monthlyCost => 'هزینه ماهانه برق:';

  @override
  String get yearlyCost => 'هزینه سالانه برق:';

  @override
  String get solarSizingTitle => 'پیشنهاد سیستم خورشیدی';

  @override
  String get panelCount => 'تعداد پنل:';

  @override
  String get arrayCapacity => 'ظرفیت آرایه:';

  @override
  String get inverterCapacity => 'ظرفیت اینورتر:';

  @override
  String get batteryCapacity => 'ظرفیت باتری پشتیبان:';

  @override
  String get irradianceFactor => 'ضریب تابش خورشید:';

  @override
  String get consumptionByAppliance => 'مصرف به تفکیک وسیله';

  @override
  String get consumptionComparison => 'مقایسه مصرف روزانه و ماهانه';

  @override
  String get dailyShort => 'روزانه';

  @override
  String get monthlyShort => 'ماهانه';

  @override
  String panelsUnit(int count) {
    return '$count پنل';
  }

  @override
  String get invalidApplianceInput => 'نام و توان وسیله را به درستی وارد کنید.';

  @override
  String get onboardingTitle1 => 'به ماشین‌حساب خورشیدی خوش آمدید';

  @override
  String get onboardingBody1 =>
      'مصرف روزانه انرژی خود را تخمین بزنید و ببینید خورشید چگونه خانه‌تان را تأمین می‌کند.';

  @override
  String get onboardingTitle2 => 'وسایل خود را انتخاب کنید';

  @override
  String get onboardingBody2 =>
      'دستگاه‌ها را انتخاب کنید، ساعات کارکرد را تنظیم کنید و مصرف را فوراً ببینید.';

  @override
  String get onboardingTitle3 => 'سیستم خورشیدی خود را برنامه‌ریزی کنید';

  @override
  String get onboardingBody3 =>
      'پیشنهاد اندازه‌گیری، برآورد هزینه و توصیه‌های هوشمند دریافت کنید.';

  @override
  String get onboardingNext => 'بعدی';

  @override
  String get onboardingBack => 'قبلی';

  @override
  String get onboardingGetStarted => 'شروع کنید';

  @override
  String get historyTitle => 'تاریخچه محاسبات';

  @override
  String get historyEmpty => 'هنوز محاسبه‌ای ذخیره نشده است.';

  @override
  String historyApplianceSummary(int count, String summary) {
    return '$count وسیله: $summary';
  }

  @override
  String get searchAppliances => 'جستجوی وسایل…';

  @override
  String get noSearchResults => 'وسیله‌ای یافت نشد.';

  @override
  String get themeToggle => 'تغییر تم';

  @override
  String get languageToggle => 'تغییر زبان';

  @override
  String get shareResults => 'اشتراک‌گذاری نتایج';

  @override
  String co2TreeEquivalent(String count) {
    return '≈ $count درخت در سال برای جبران';
  }

  @override
  String co2CarKmEquivalent(String km) {
    return '≈ $km کیلومتر رانندگی خودرو';
  }

  @override
  String get aiFallbackNotice =>
      'هوش مصنوعی در دسترس نیست — پیشنهاد فرمولی نمایش داده می‌شود.';

  @override
  String get refreshAnalysis => 'بروزرسانی تحلیل هوشمند';
}
