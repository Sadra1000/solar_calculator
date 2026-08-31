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
/// Web builds intentionally ignore `DEEPSEEK_API_KEY`. Configure an HTTPS
/// OpenAI-compatible proxy through `DEEPSEEK_PROXY_URL` instead so no secret is
/// embedded in the public JavaScript bundle.
abstract final class ApiConfig {
  static const String deepSeekApiKey = credentials.deepSeekApiKey;

  static const String deepSeekProxyUrl = String.fromEnvironment(
    'DEEPSEEK_PROXY_URL',
  );

  static const String deepSeekBaseUrl = 'https://api.deepseek.com';

  static const String chatCompletionsPath = '/chat/completions';

  /// Non-thinking mode successor to deprecated `deepseek-chat`.
  /// See https://api-docs.deepseek.com/
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
