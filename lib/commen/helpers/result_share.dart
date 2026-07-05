import 'package:solar_calculator/features/result/repository/model.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

String buildResultShareText(AppLocalizations l10n, ResulteModel data) {
  final buffer = StringBuffer()
    ..writeln(l10n.resultsTitle)
    ..writeln()
    ..writeln('${l10n.dailyConsumption} ${data.dailyConsumption.toStringAsFixed(2)} kWh')
    ..writeln('${l10n.monthlyConsumption} ${data.monthlyConsumption.toStringAsFixed(2)} kWh')
    ..writeln('${l10n.yearlyConsumption} ${data.yearlyConsumption.toStringAsFixed(2)} kWh')
    ..writeln('${l10n.yearlyCo2Production} ${data.yearlyCo2Production.toStringAsFixed(2)} kg');

  if (data.monthlyCostToman > 0) {
    buffer.writeln('${l10n.monthlyCost} ${data.monthlyCostToman.toStringAsFixed(0)}');
    buffer.writeln('${l10n.yearlyCost} ${data.yearlyCostToman.toStringAsFixed(0)}');
  }

  if (data.analysis.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln(data.analysis);
  }

  return buffer.toString().trim();
}
