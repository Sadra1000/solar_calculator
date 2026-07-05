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
}
