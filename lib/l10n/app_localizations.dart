import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// Application title shown in the app bar
  ///
  /// In en, this message translates to:
  /// **'Solar Calculator'**
  String get appTitle;

  /// Placeholder when the user has not selected any appliances
  ///
  /// In en, this message translates to:
  /// **'No items selected'**
  String get noItemsSelected;

  /// Primary action button on the home screen
  ///
  /// In en, this message translates to:
  /// **'Calculate!'**
  String get calculate;

  /// Title for the results screen
  ///
  /// In en, this message translates to:
  /// **'Calculation Results'**
  String get resultsTitle;

  /// Label for daily energy consumption
  ///
  /// In en, this message translates to:
  /// **'Daily consumption:'**
  String get dailyConsumption;

  /// Label for monthly energy consumption
  ///
  /// In en, this message translates to:
  /// **'Monthly consumption:'**
  String get monthlyConsumption;

  /// Label for yearly energy consumption
  ///
  /// In en, this message translates to:
  /// **'Yearly consumption:'**
  String get yearlyConsumption;

  /// Label for yearly CO2 production
  ///
  /// In en, this message translates to:
  /// **'Yearly CO2 production:'**
  String get yearlyCo2Production;

  /// Total power label for a selected appliance group
  ///
  /// In en, this message translates to:
  /// **'Total power: {power}'**
  String totalPower(String power);

  /// Tooltip for increasing appliance count
  ///
  /// In en, this message translates to:
  /// **'Add one'**
  String get addOne;

  /// Tooltip for decreasing appliance count
  ///
  /// In en, this message translates to:
  /// **'Remove one'**
  String get removeOne;

  /// Tooltip for removing all appliances of a type
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get removeAll;

  /// Dialog title when choosing an appliance from a category
  ///
  /// In en, this message translates to:
  /// **'Select from {category} category'**
  String selectFromCategory(String category);

  /// Appliance power usage subtitle
  ///
  /// In en, this message translates to:
  /// **'{power} watts'**
  String watts(int power);

  /// Button to add a custom appliance
  ///
  /// In en, this message translates to:
  /// **'Add new appliance'**
  String get addNewAppliance;

  /// Snackbar shown for unimplemented custom appliance flow
  ///
  /// In en, this message translates to:
  /// **'This feature is not implemented yet.'**
  String get featureNotImplemented;

  /// Generic cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Dialog title for selecting daily operating hours
  ///
  /// In en, this message translates to:
  /// **'Operating hours for {name}'**
  String operatingHours(String name);

  /// Instruction text in the hours selection dialog
  ///
  /// In en, this message translates to:
  /// **'Please specify how many hours per day this appliance is on.'**
  String get hoursPrompt;

  /// Selected hours value label
  ///
  /// In en, this message translates to:
  /// **'{hours} hours'**
  String hoursValue(String hours);

  /// Dismiss action in the hours dialog
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Confirm action in the hours dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// API rate limit error message
  ///
  /// In en, this message translates to:
  /// **'You cannot use this service more than 4 times per day.'**
  String get rateLimitError;

  /// HTTP 404 error message
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// HTTP 401 error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please contact support.'**
  String get authError;

  /// HTTP 500 error message
  ///
  /// In en, this message translates to:
  /// **'Server is not responding.'**
  String get serverError;

  /// Generic connection error with response body
  ///
  /// In en, this message translates to:
  /// **'Check your device internet connection.'**
  String get connectionError;

  /// No response connection error
  ///
  /// In en, this message translates to:
  /// **'Please make sure you are connected to the internet.'**
  String get noInternet;

  /// Fallback error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get genericError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
