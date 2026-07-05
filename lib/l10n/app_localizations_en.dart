// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Solar Calculator';

  @override
  String get noItemsSelected => 'No items selected';

  @override
  String get calculate => 'Calculate!';

  @override
  String get resultsTitle => 'Calculation Results';

  @override
  String get dailyConsumption => 'Daily consumption:';

  @override
  String get monthlyConsumption => 'Monthly consumption:';

  @override
  String get yearlyConsumption => 'Yearly consumption:';

  @override
  String get yearlyCo2Production => 'Yearly CO2 production:';

  @override
  String totalPower(String power) {
    return 'Total power: $power';
  }

  @override
  String get addOne => 'Add one';

  @override
  String get removeOne => 'Remove one';

  @override
  String get removeAll => 'Remove all';

  @override
  String selectFromCategory(String category) {
    return 'Select from $category category';
  }

  @override
  String watts(int power) {
    return '$power watts';
  }

  @override
  String get addNewAppliance => 'Add new appliance';

  @override
  String get featureNotImplemented => 'This feature is not implemented yet.';

  @override
  String get cancel => 'Cancel';

  @override
  String operatingHours(String name) {
    return 'Operating hours for $name';
  }

  @override
  String get hoursPrompt =>
      'Please specify how many hours per day this appliance is on.';

  @override
  String hoursValue(String hours) {
    return '$hours hours';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get confirm => 'Confirm';

  @override
  String get rateLimitError =>
      'You cannot use this service more than 4 times per day.';

  @override
  String get notFound => 'Not found';

  @override
  String get authError => 'Something went wrong. Please contact support.';

  @override
  String get serverError => 'Server is not responding.';

  @override
  String get connectionError => 'Check your device internet connection.';

  @override
  String get noInternet =>
      'Please make sure you are connected to the internet.';

  @override
  String get genericError => 'An unexpected error occurred.';
}
