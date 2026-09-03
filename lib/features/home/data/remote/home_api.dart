// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:solar_calculator/config/api_config.dart';
import 'package:solar_calculator/features/home/data/remote/deepseek_prompt.dart';

class HomeApi {
  final Dio dio;
  HomeApi({required this.dio});

  Map<String, dynamic> _requestBody({
    required String userMessage,
    required bool stream,
    required int usdToToman,
    String? rateDate,
  }) {
    return {
      'model': ApiConfig.model,
      'thinking': {'type': 'disabled'},
      'messages': [
        {
          'role': 'system',
          'content': DeepSeekPrompt.buildSystemMessage(
            usdToToman: usdToToman,
            rateDate: rateDate,
          ),
        },
        {'role': 'user', 'content': userMessage},
      ],
      'stream': stream,
    };
  }

  Options _authOptions({required bool stream, Duration? receiveTimeout}) {
    final headers = <String, String>{};
    if (ApiConfig.shouldSendAuthorization) {
      headers['Authorization'] = 'Bearer ${ApiConfig.deepSeekApiKey}';
    }
    return Options(
      headers: headers,
      responseType: stream ? ResponseType.stream : ResponseType.json,
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 30),
    );
  }

  void _ensureAiConfigured() {
    if (!ApiConfig.hasAiConfiguration) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConfig.chatCompletionsUrl),
        message: 'AI_ENDPOINT is not configured',
        type: DioExceptionType.unknown,
      );
    }
  }

  Future<Response<dynamic>> callDeepSeekApi(
    String userMessage, {
    required int usdToToman,
    String? rateDate,
  }) async {
    _ensureAiConfigured();

    return dio.post(
      ApiConfig.chatCompletionsUrl,
      data: _requestBody(
        userMessage: userMessage,
        stream: false,
        usdToToman: usdToToman,
        rateDate: rateDate,
      ),
      options: _authOptions(stream: false),
    );
  }

  /// Server-sent events stream of text deltas. Caller must handle errors.
  Stream<String> streamDeepSeekApi(
    String userMessage, {
    required int usdToToman,
    String? rateDate,
  }) async* {
    _ensureAiConfigured();

    final response = await dio.post<ResponseBody>(
      ApiConfig.chatCompletionsUrl,
      data: _requestBody(
        userMessage: userMessage,
        stream: true,
        usdToToman: usdToToman,
        rateDate: rateDate,
      ),
      options: _authOptions(
        stream: true,
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    final body = response.data;
    if (body == null) return;

    final lineStream = body.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lineStream) {
      final chunk = _parseSseLine(line);
      if (chunk != null) yield chunk;
    }
  }

  String? _parseSseLine(String line) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('data:')) return null;

    final payload = trimmed.substring(5).trim();
    if (payload == '[DONE]') return null;

    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final choices = json['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return null;

      final delta =
          (choices.first as Map<String, dynamic>)['delta']
              as Map<String, dynamic>?;
      final content = delta?['content'];
      if (content is String && content.isNotEmpty) return content;
    } catch (_) {
      return null;
    }
    return null;
  }
}
