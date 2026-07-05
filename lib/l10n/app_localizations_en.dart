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

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get selectAppliancesToCalculate =>
      'Select at least one appliance to calculate.';

  @override
  String liveDailyConsumption(String value) {
    return 'Estimated daily consumption: $value';
  }

  @override
  String get deepSeekApiKeyMissing =>
      'The AI API key (DEEPSEEK_API_KEY) is not configured. Add it to your .env file to enable smart analysis.';

  @override
  String get analysisNotAvailable =>
      'AI analysis is not available. Local calculation results are shown below.';

  @override
  String get enableAiAnalysis => 'Include AI solar advice (DeepSeek)';

  @override
  String get presetsTitle => 'Quick presets';

  @override
  String get editHours => 'Edit hours';

  @override
  String get applianceName => 'Appliance name';

  @override
  String get powerWatts => 'Power (watts)';

  @override
  String get selectCity => 'City';

  @override
  String get electricityRate => 'Electricity rate (Toman/kWh)';

  @override
  String get monthlyCost => 'Monthly electricity cost:';

  @override
  String get yearlyCost => 'Yearly electricity cost:';

  @override
  String get solarSizingTitle => 'Suggested solar system';

  @override
  String get panelCount => 'Panel count:';

  @override
  String get arrayCapacity => 'Array capacity:';

  @override
  String get inverterCapacity => 'Inverter capacity:';

  @override
  String get batteryCapacity => 'Backup battery capacity:';

  @override
  String get irradianceFactor => 'Solar irradiance factor:';

  @override
  String get consumptionByAppliance => 'Consumption by appliance';

  @override
  String get consumptionComparison => 'Daily vs monthly consumption';

  @override
  String get dailyShort => 'Daily';

  @override
  String get monthlyShort => 'Monthly';

  @override
  String panelsUnit(int count) {
    return '$count panels';
  }

  @override
  String get invalidApplianceInput => 'Please enter a valid name and wattage.';

  @override
  String get onboardingTitle1 => 'Welcome to Solar Calculator';

  @override
  String get onboardingBody1 =>
      'Estimate your daily energy use and see how solar can power your home.';

  @override
  String get onboardingTitle2 => 'Select your appliances';

  @override
  String get onboardingBody2 =>
      'Pick devices, set operating hours, and see consumption instantly.';

  @override
  String get onboardingTitle3 => 'Plan your solar system';

  @override
  String get onboardingBody3 =>
      'Get sizing recommendations, cost estimates, and smart advice.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get historyTitle => 'Calculation history';

  @override
  String get historyEmpty => 'No saved calculations yet.';

  @override
  String historyApplianceSummary(int count, String summary) {
    return '$count appliances: $summary';
  }

  @override
  String get searchAppliances => 'Search appliances…';

  @override
  String get noSearchResults => 'No appliances found.';

  @override
  String get themeToggle => 'Toggle theme';

  @override
  String get languageToggle => 'Toggle language';

  @override
  String get shareResults => 'Share results';

  @override
  String co2TreeEquivalent(String count) {
    return '≈ $count trees per year to offset';
  }

  @override
  String co2CarKmEquivalent(String km) {
    return '≈ $km km of driving';
  }

  @override
  String get aiFallbackNotice =>
      'AI unavailable — showing formula-based recommendation.';

  @override
  String get refreshAnalysis => 'Refresh AI analysis';
}
