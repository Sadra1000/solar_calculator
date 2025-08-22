import 'package:dio/dio.dart';
import 'package:solar_calculator/commen/data_state.dart';

class CheckExceptions {
  CheckExceptions(Object? error);

  static Future<DataFailed> response(Response? response) async {
    // print(response?.statusCode ?? "aaaa");
    switch (response?.statusCode ?? -1) {
      case 400:
        return DataFailed(
          response?.data['message'] ??
              "شما نمیتوانید بیش از 4 بار در روز از این سرویس استفاده کنید",
        );
      case 404:
        return DataFailed("Not Found");
      case 401:
        return DataFailed(
          response?.data['message'] ??
              "مشکلی پیش اومده، لطفا با پشتیبانی در ارتباط باشید.",
        );
      case 500:
        return DataFailed("Server is Not Responding,");
      default:
        if (response != null) {
          return DataFailed(
            response.data['message'] ??
                ".اتصال به اینترنت  دستگاه را برسی کنید",
          );
        } else {
          return const DataFailed(
            ".لطفا از اتصال به اینترنت اطمینان حاصل کنید",
          );
        }
    }
  }

  static Future<DataState> getError(Object error) async {
    if (error is DioException) {
      return response(error.response);
    } else {
      return const DataFailed("There is an Error");
    }
  }
}
