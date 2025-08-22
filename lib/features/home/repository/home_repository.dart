// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:solar_calculator/commen/error_handler/check_exceptions.dart';
import 'package:solar_calculator/commen/data_state.dart';
import 'package:solar_calculator/features/home/data/remote/home_api.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';

class HomeRepository {
  final String applianceJson;
  final HomeApi api;
  HomeRepository({required this.api, required this.applianceJson});

  DataState<List<AppliancesCatgory>> getAppliances() {
    try {
      List<AppliancesCatgory> list = [];
      for (var element in (jsonDecode(applianceJson) as List<dynamic>)) {
        list.add(AppliancesCatgory.fromMap(element));
      }
      return DataSuccess(list);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  /// تابعی که لیست وسایل برقی را دریافت کرده و مدل مصرف را برمی‌گرداند
  Map<String, dynamic> calculateConsumption(List<Appliance> appliances) {
    // مقادیر ثابت برای محاسبات
    const int daysInYear = 365;
    const int monthsInYear = 12;
    // ضریب متوسط جهانی تولید دی‌اکسید کربن به ازای هر کیلووات‌ساعت
    const double kgCo2PerKwh = 0.417;

    // محاسبه مجموع مصرف روزانه تمام دستگاه‌ها به کیلووات‌ساعت
    double totalDailyKwh = 0.0;
    for (final appliance in appliances) {
      // تبدیل وات به کیلووات (تقسیم بر 1000) و ضرب در ساعات استفاده
      final dailyKwh = (appliance.powerUsage / 1000.0) * appliance.houres;
      totalDailyKwh += dailyKwh;
    }

    // محاسبه مقادیر نهایی
    final double yearlyKwh = totalDailyKwh * daysInYear;
    final double monthlyKwh = yearlyKwh / monthsInYear;
    final double yearlyCo2 = yearlyKwh * kgCo2PerKwh;

    // ساخت و بازگرداندن مدل خروجی
    return {
      "dailyConsumption": totalDailyKwh,
      "monthlyConsumption": monthlyKwh,
      "yearlyConsumption": yearlyKwh,
      "yearlyCo2Production": yearlyCo2,
    };
  }

  Future<DataState<dynamic>> callDeepSeek(List<Appliance> list) async {
    try {
      Response res = await api.callDeepSeekApi(
        jsonEncode(_sortAppliances(list)),
      );
      return DataSuccess((res.data as Map<String, dynamic>)["response"]);
    } catch (e) {
      return await CheckExceptions.getError(e);
    }
  }

  List<Map<String, dynamic>> _sortAppliances(List<Appliance> list) {
    List<Map<String, dynamic>> sortedList = [];
    for (var appliance in list) {
      if (sortedList.any((element) => element["name"] == appliance.name)) {
        sortedList
            .where((element) => element["name"] == appliance.name)
            .first["count"]++;
      } else {
        // اگر وسیله جدید بود، یک ورودی جدید در مپ ایجاد کن.
        sortedList.add({
          'name': appliance.name,
          'consumption': appliance.powerUsage,
          'count': 1, // شمارش از 1 شروع می شود
          'hours': appliance.houres,
        });
      }
    }
    return sortedList;
  }
}
