import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/services/shared_operator.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'package:solar_calculator/locator.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final entries = locator<SharedPrefOperator>().loadCalculationHistory();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        centerTitle: true,
      ),
      body:
          entries.isEmpty
              ? Center(child: Text(l10n.historyEmpty))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    entry.timestampMs,
                  );
                  final dateStr = DateFormat.yMMMd(
                    locale.languageCode,
                  ).add_jm().format(date).localizedDigits(locale);

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateStr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.historyApplianceSummary(
                              entry.applianceCount,
                              entry.applianceSummary,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(height: 20),
                          _metricRow(
                            context,
                            l10n.dailyConsumption,
                            entry.dailyConsumption.toStringAsFixed(2).tokWhPersian(
                              locale,
                            ),
                          ),
                          _metricRow(
                            context,
                            l10n.monthlyConsumption,
                            entry.monthlyConsumption
                                .toStringAsFixed(2)
                                .tokWhPersian(locale),
                          ),
                          _metricRow(
                            context,
                            l10n.yearlyConsumption,
                            entry.yearlyConsumption
                                .toStringAsFixed(2)
                                .tokWhPersian(locale),
                          ),
                          _metricRow(
                            context,
                            l10n.yearlyCo2Production,
                            entry.yearlyCo2Production
                                .toStringAsFixed(2)
                                .tokgPersian(locale),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _metricRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
