import 'package:solar_calculator/config/api_credentials_native.dart'
    if (dart.library.js_interop) 'package:solar_calculator/config/api_credentials_web.dart'
    as credentials;

/// Optional DeepSeek client configuration.
///
/// Inject the API key at build/run time:
///   --dart-define=DEEPSEEK_API_KEY=sk-...
/// or:
///   --dart-define-from-file=dart_defines.json
///
/// Web builds can use either `DEEPSEEK_API_KEY` directly or an HTTPS
/// OpenAI-compatible endpoint supplied through `DEEPSEEK_PROXY_URL`.
abstract final class ApiConfig {
  static const String deepSeekApiKey = credentials.deepSeekApiKey;

  static const String deepSeekProxyUrl = String.fromEnvironment(
    'DEEPSEEK_PROXY_URL',
  );

  static const String deepSeekBaseUrl = 'https://api.deepseek.com';

  static const String chatCompletionsPath = '/chat/completions';

  /// DeepSeek model used for analysis. Thinking is explicitly disabled in the
  /// Chat Completions request so the model returns the final answer directly.
  static const String model = String.fromEnvironment(
    'DEEPSEEK_MODEL',
    defaultValue: 'deepseek-v4-pro',
  );

  static bool get hasValidProxy {
    final uri = Uri.tryParse(deepSeekProxyUrl);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  static bool get hasApiKey => deepSeekApiKey.isNotEmpty;

  static bool get hasAiConfiguration => hasValidProxy || hasApiKey;

  static bool get shouldSendAuthorization => !hasValidProxy && hasApiKey;

  static String get chatCompletionsUrl =>
      hasValidProxy ? deepSeekProxyUrl : chatCompletionsPath;
}
