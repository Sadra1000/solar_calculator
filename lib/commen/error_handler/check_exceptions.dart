import 'package:dio/dio.dart';
import 'package:solar_calculator/commen/helpers/api_errors.dart';
import 'package:solar_calculator/commen/data_state.dart';

class CheckExceptions {
  CheckExceptions(Object? error);

  static Future<DataFailed> response(Response? response) async {
    final errorMessage = _extractMessage(response?.data);

    switch (response?.statusCode ?? -1) {
      case 400:
        return DataFailed(errorMessage ?? ApiErrorKeys.rateLimit);
      case 404:
        return const DataFailed(ApiErrorKeys.notFound);
      case 401:
        return DataFailed(errorMessage ?? ApiErrorKeys.auth);
      case 500:
        return const DataFailed(ApiErrorKeys.server);
      default:
        if (response != null) {
          return DataFailed(errorMessage ?? ApiErrorKeys.connection);
        } else {
          return const DataFailed(ApiErrorKeys.noInternet);
        }
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is! Map) return null;
    final direct = data['message'];
    if (direct is String && direct.isNotEmpty) return direct;
    final nested = data['error'];
    if (nested is Map && nested['message'] is String) {
      return nested['message'] as String;
    }
    return null;
  }

  static Future<DataState> getError(Object error) async {
    if (error is DioException) {
      if (error.message?.contains('DEEPSEEK_API_KEY') ?? false) {
        return const DataFailed(ApiErrorKeys.auth);
      }
      return response(error.response);
    } else {
      return const DataFailed(ApiErrorKeys.generic);
    }
  }
}
