// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:solar_calculator/config/api_config.dart';

class HomeApi {
  final Dio dio;
  HomeApi({required this.dio});

  Future<Response<dynamic>> callDeepSeekApi(String appliancesDataJson) async {
    if (!ApiConfig.hasApiKey) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConfig.chatCompletionsPath),
        message: 'DEEPSEEK_API_KEY is not configured',
        type: DioExceptionType.unknown,
      );
    }

    final prompt =
        'You are a solar energy advisor. Analyze this household appliance '
        'list and respond in Persian with practical solar panel recommendations. '
        'Data: $appliancesDataJson';

    return dio.post(
      ApiConfig.chatCompletionsPath,
      data: {
        'model': ApiConfig.model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${ApiConfig.deepSeekApiKey}'},
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
