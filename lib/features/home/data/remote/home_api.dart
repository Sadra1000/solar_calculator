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
  }) {
    return {
      'model': ApiConfig.model,
      'messages': [
        {'role': 'system', 'content': DeepSeekPrompt.systemMessage},
        {'role': 'user', 'content': userMessage},
      ],
      'stream': stream,
    };
  }

  Options _authOptions({
    required bool stream,
    Duration? receiveTimeout,
  }) {
    return Options(
      headers: {'Authorization': 'Bearer ${ApiConfig.deepSeekApiKey}'},
      responseType: stream ? ResponseType.stream : ResponseType.json,
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 30),
    );
  }

  void _ensureApiKey() {
    if (!ApiConfig.hasApiKey) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConfig.chatCompletionsPath),
        message: 'DEEPSEEK_API_KEY is not configured',
        type: DioExceptionType.unknown,
      );
    }
  }

  Future<Response<dynamic>> callDeepSeekApi(String userMessage) async {
    _ensureApiKey();

    return dio.post(
      ApiConfig.chatCompletionsPath,
      data: _requestBody(userMessage: userMessage, stream: false),
      options: _authOptions(stream: false),
    );
  }

  /// Server-sent events stream of text deltas. Caller must handle errors.
  Stream<String> streamDeepSeekApi(String userMessage) async* {
    _ensureApiKey();

    final response = await dio.post<ResponseBody>(
      ApiConfig.chatCompletionsPath,
      data: _requestBody(userMessage: userMessage, stream: true),
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
