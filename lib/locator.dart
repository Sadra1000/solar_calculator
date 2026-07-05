import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_calculator/commen/services/dio_interceptor.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/config/api_config.dart';
import 'package:solar_calculator/features/home/data/remote/home_api.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';
import 'package:flutter/services.dart';

final locator = GetIt.instance;

Future<void> setupLocato() async {
  locator.registerSingleton<SharedPrefOperator>(
    SharedPrefOperator(await SharedPreferences.getInstance()),
  );
  final applianceJson = await rootBundle.loadString('assets/data.txt');

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.deepSeekBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(DioInterceptor(dio));
  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<ThemeCubit>(ThemeCubit());
  locator.registerSingleton<HomeApi>(HomeApi(dio: locator()));
  locator.registerSingleton<HomeRepository>(
    HomeRepository(applianceJson: applianceJson, api: locator()),
  );
  locator.registerSingleton<HomeCubit>(
    HomeCubit(repo: locator<HomeRepository>()),
  );
}
