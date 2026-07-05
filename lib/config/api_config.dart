/// DeepSeek client configuration (no backend required).
///
/// Inject the API key at build/run time:
///   --dart-define=DEEPSEEK_API_KEY=sk-...
/// or:
///   --dart-define-from-file=dart_defines.json
///
/// On web builds the key is embedded in compiled JS — use a dedicated
/// DeepSeek key with usage limits for public portfolio demos.
abstract final class ApiConfig {
  static const String deepSeekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');

  static const String deepSeekBaseUrl = 'https://api.deepseek.com';

  static const String chatCompletionsPath = '/chat/completions';

  /// Non-thinking mode successor to deprecated `deepseek-chat`.
  /// See https://api-docs.deepseek.com/
  static const String model = String.fromEnvironment(
    'DEEPSEEK_MODEL',
    defaultValue: 'deepseek-v4-flash',
  );

  static bool get hasApiKey => deepSeekApiKey.isNotEmpty;
}
