import 'package:solar_calculator/l10n/app_localizations.dart';

abstract final class ApiErrorKeys {
  static const rateLimit = 'rate_limit';
  static const notFound = 'not_found';
  static const auth = 'auth';
  static const deepSeekApiKeyMissing = 'deepseek_api_key_missing';
  static const server = 'server';
  static const connection = 'connection';
  static const noInternet = 'no_internet';
  static const generic = 'generic';
}

String localizeApiError(AppLocalizations l10n, String key) {
  return switch (key) {
    ApiErrorKeys.rateLimit => l10n.rateLimitError,
    ApiErrorKeys.notFound => l10n.notFound,
    ApiErrorKeys.auth => l10n.authError,
    ApiErrorKeys.deepSeekApiKeyMissing => l10n.deepSeekApiKeyMissing,
    ApiErrorKeys.server => l10n.serverError,
    ApiErrorKeys.connection => l10n.connectionError,
    ApiErrorKeys.noInternet => l10n.noInternet,
    ApiErrorKeys.generic => l10n.genericError,
    _ => key,
  };
}
