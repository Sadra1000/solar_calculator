import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_calculator/commen/constants.dart';
import 'package:solar_calculator/commen/services/dio_interceptor.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/features/home/data/remote/home_api.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/repository/home_repository.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocato() async {
  //! operators
  locator.registerSingleton<SharedPrefOperator>(
    SharedPrefOperator(await SharedPreferences.getInstance()),
  );

  //! dio
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      baseUrl: Constants.baseUrl,
    ),
  );
  dio.interceptors.add(DioInterceptor(dio));
  locator.registerSingleton<Dio>(dio);
  //! data

  //! features
  locator.registerSingleton<ThemeCubit>(ThemeCubit());
  //---
  locator.registerSingleton<HomeApi>(HomeApi(dio: locator()));
  locator.registerSingleton<HomeRepository>(
    HomeRepository(
      applianceJson: await rootBundle.loadString('assets/data.json'),
      api: locator(),
    ),
  );
  locator.registerSingleton<HomeCubit>(
    HomeCubit(repo: locator<HomeRepository>()),
  );
  //---

  // locator.registerSingleton<DeepSeekCall>(DeepSeekCall(dio: locator()));
  // locator.registerSingleton<DeepRep>(
  //   DeepRep(deepSeekCall: locator(), box: locator()),
  // );
}
