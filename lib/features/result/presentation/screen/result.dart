import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:solar_calculator/commen/constants.dart';
import 'package:solar_calculator/commen/helpers/co2_equivalents.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/features/result/presentation/cubit/result_cubit.dart';
import 'package:solar_calculator/features/result/presentation/cubit/result_state.dart';
import 'package:solar_calculator/features/result/repository/model.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'dart:async';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textDirection =
        Localizations.localeOf(context).languageCode == 'fa'
            ? TextDirection.rtl
            : TextDirection.ltr;

    return BlocConsumer<ResultCubit, ResultState>(
      listenWhen: (previous, current) => previous.shareMessage != current.shareMessage,
      listener: (context, state) {
        final msg = state.shareMessage;
        if (msg == null) return;
        if (msg == 'shared' && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.shareResults)),
          );
        }
        context.read<ResultCubit>().clearShareMessage();
      },
      builder: (context, state) {
        final data = state.data;
        final cubit = context.read<ResultCubit>();

        return Directionality(
          textDirection: textDirection,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: Text(
                l10n.resultsTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              centerTitle: true,
              actions: [
                if (state.session.requestAi)
                  IconButton(
                    icon:
                        state.isRefreshing
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.refresh),
                    tooltip: l10n.refreshAnalysis,
                    onPressed:
                        state.isRefreshing ? null : () => cubit.refresh(),
                  ),
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: l10n.shareResults,
                  onPressed: () => cubit.share(l10n),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final content =
                    isLargeScreen(constraints.maxWidth)
                        ? _buildLargeScreenLayout(
                          context,
                          data: data,
                          isStreaming: state.isStreaming,
                          isFallback: state.isFallback,
                        )
                        : _buildSmallScreenLayout(
                          context,
                          data: data,
                          isStreaming: state.isStreaming,
                          isFallback: state.isFallback,
                        );

                return constrainContent(
                  maxWidth: AppBreakpoints.resultContentMaxWidth,
                  child: content,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallScreenLayout(
    BuildContext context, {
    required ResulteModel data,
    required bool isStreaming,
    required bool isFallback,
  }) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isFallback) _FallbackBanner(),
          _AnalysisPanel(
            markdown: data.analysis,
            theme: theme,
            isStreaming: isStreaming,
          ),
          const SizedBox(height: 16),
          _ConsumptionCharts(data: data),
          const SizedBox(height: 16),
          _SolarSizingPanel(data: data),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildListOfCalculatedItems(
                context: context,
                data: data,
                locale: locale,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeScreenLayout(
    BuildContext context, {
    required ResulteModel data,
    required bool isStreaming,
    required bool isFallback,
  }) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isFallback) _FallbackBanner(),
          _AnalysisPanel(
            markdown: data.analysis,
            theme: theme,
            isLargeScreen: true,
            isStreaming: isStreaming,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ConsumptionCharts(data: data)),
              const SizedBox(width: 16),
              Expanded(child: _SolarSizingPanel(data: data)),
            ],
          ),
          const SizedBox(height: 24),
          AnimationLimiter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: _buildListOfCalculatedItems(
                    context: context,
                    data: data,
                    locale: locale,
                    theme: theme,
                    isLargeScreen: true,
                    tileWidth: (constraints.maxWidth - 16) / 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListOfCalculatedItems({
    required BuildContext context,
    required ResulteModel data,
    required Locale locale,
    required ThemeData theme,
    bool isLargeScreen = false,
    double? tileWidth,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      (l10n.dailyConsumption, data.dailyConsumption.toStringAsFixed(2)),
      (l10n.monthlyConsumption, data.monthlyConsumption.toStringAsFixed(2)),
      (l10n.yearlyConsumption, data.yearlyConsumption.toStringAsFixed(2)),
      (l10n.yearlyCo2Production, data.yearlyCo2Production.toStringAsFixed(2)),
      (
        l10n.monthlyCost,
        _formatToman(data.monthlyCostToman, locale),
      ),
      (
        l10n.yearlyCost,
        _formatToman(data.yearlyCostToman, locale),
      ),
    ];

    final co2Subtitle = _co2EquivalentsText(l10n, data.yearlyCo2Production, locale);

    return List.generate(items.length, (index) {
      final item = items[index];
      final isCost = index >= 4;
      final value =
          isCost
              ? item.$2
              : index == 3
              ? item.$2.tokgPersian(locale)
              : item.$2.tokWhPersian(locale);

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: _buildResultTile(
              theme: theme,
              title: item.$1,
              value: value,
              subtitle: index == 3 ? co2Subtitle : null,
              isLargeScreen: isLargeScreen,
              width: tileWidth,
            ),
          ),
        ),
      );
    });
  }

  String _co2EquivalentsText(
    AppLocalizations l10n,
    double yearlyKgCo2,
    Locale locale,
  ) {
    final trees = Co2Equivalents.treeCount(yearlyKgCo2).round();
    final km = Co2Equivalents.carKmEquivalent(yearlyKgCo2).round();
    return '${l10n.co2TreeEquivalent(trees.toString().localizedDigits(locale))}\n${l10n.co2CarKmEquivalent(km.toString().localizedDigits(locale))}';
  }

  String _formatToman(double amount, Locale locale) {
    return amount
        .round()
        .toString()
        .localizedDigits(locale)
        .toTomanPersian(locale);
  }

  Widget _buildResultTile({
    required String title,
    required String value,
    required bool isLargeScreen,
    required ThemeData theme,
    double? width,
    String? subtitle,
  }) {
    final content = isLargeScreen
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 24,
                  child: Text(title, textAlign: TextAlign.start),
                ),
                Expanded(
                  flex: 30,
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.end,
                ),
              ),
          ],
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: theme.colorScheme.primary),
        color: theme.colorScheme.tertiaryContainer,
      ),
      height: subtitle != null ? null : (isLargeScreen ? 140 : 72),
      constraints: BoxConstraints(minHeight: isLargeScreen ? 140 : 72),
      width: isLargeScreen ? width : double.infinity,
      child: content,
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialBanner(
        content: Text(l10n.aiFallbackNotice),
        leading: const Icon(Icons.info_outline),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(l10n.dismiss),
          ),
        ],
      ),
    );
  }
}

class _ConsumptionCharts extends StatelessWidget {
  const _ConsumptionCharts({required this.data});

  final ResulteModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    final pieData =
        data.applianceShares
            .map(
              (s) => _ChartPoint(
                label: s.name,
                value: s.dailyKwh,
              ),
            )
            .toList();

    final barData = [
      _ChartPoint(
        label: l10n.dailyShort,
        value: data.dailyConsumption,
      ),
      _ChartPoint(
        label: l10n.monthlyShort,
        value: data.monthlyConsumption,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.consumptionByAppliance,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: SfCircularChart(
                legend: const Legend(isVisible: true),
                series: <PieSeries<_ChartPoint, String>>[
                  PieSeries<_ChartPoint, String>(
                    dataSource: pieData,
                    xValueMapper: (p, _) => p.label,
                    yValueMapper: (p, _) => p.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.consumptionComparison,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'kWh'),
                ),
                series: <ColumnSeries<_ChartPoint, String>>[
                  ColumnSeries<_ChartPoint, String>(
                    dataSource: barData,
                    xValueMapper: (p, _) => p.label,
                    yValueMapper: (p, _) => p.value,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      builder: (
                        dynamic value,
                        dynamic point,
                        dynamic series,
                        int pointIndex,
                        int seriesIndex,
                      ) {
                        final v = (point.y as num).toDouble();
                        return Text(
                          v.toStringAsFixed(1).localizedDigits(locale),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SolarSizingPanel extends StatelessWidget {
  const _SolarSizingPanel({required this.data});

  final ResulteModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final solar = data.solarSizing;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.solarSizingTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _solarRow(
              l10n.selectCity,
              solar.cityName,
              theme,
            ),
            _solarRow(
              l10n.panelCount,
              l10n.panelsUnit(solar.panelCount),
              theme,
            ),
            _solarRow(
              l10n.arrayCapacity,
              solar.arrayCapacityKw.toStringAsFixed(1).tokWPersian(locale),
              theme,
            ),
            _solarRow(
              l10n.inverterCapacity,
              solar.inverterCapacityKw.toStringAsFixed(1).tokWPersian(locale),
              theme,
            ),
            _solarRow(
              l10n.batteryCapacity,
              solar.batteryCapacityKwh.toStringAsFixed(1).tokWhPersian(locale),
              theme,
            ),
            _solarRow(
              l10n.irradianceFactor,
              '${solar.irradianceUsed.toStringAsFixed(1).localizedDigits(locale)} kWh/m²/day',
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _solarRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPoint {
  const _ChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class _AnalysisPanel extends StatelessWidget {
  final String markdown;
  final ThemeData theme;
  final bool isLargeScreen;
  final bool isStreaming;

  const _AnalysisPanel({
    required this.markdown,
    required this.theme,
    this.isLargeScreen = false,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.5,
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (markdown.isEmpty && isStreaming)
            const Center(child: CircularProgressIndicator())
          else if (markdown.isEmpty)
            Text(
              l10n.analysisNotAvailable,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else if (isStreaming)
            MarkdownBody(
              data: markdown,
              styleSheet: MarkdownStyleSheet.fromTheme(theme),
            )
          else
            _AnimatedMarkdownTyper(
              markdown: markdown,
              theme: theme,
              speed: const Duration(milliseconds: 18),
            ),
        ],
      ),
    );
  }
}

class _AnimatedMarkdownTyper extends StatefulWidget {
  final String markdown;
  final ThemeData theme;
  final Duration speed;

  const _AnimatedMarkdownTyper({
    required this.markdown,
    required this.theme,
    this.speed = const Duration(milliseconds: 24),
  });

  @override
  State<_AnimatedMarkdownTyper> createState() => _AnimatedMarkdownTyperState();
}

class _AnimatedMarkdownTyperState extends State<_AnimatedMarkdownTyper> {
  Timer? _timer;
  int _len = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() {
      _completed = false;
      _len = 0;
    });
    _timer = Timer.periodic(widget.speed, (t) {
      if (_len >= widget.markdown.length) {
        t.cancel();
        setState(() => _completed = true);
      } else {
        setState(() => _len += 2);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible =
        _completed
            ? widget.markdown
            : widget.markdown.substring(
              0,
              _len.clamp(0, widget.markdown.length),
            );
    return Stack(
      children: [
        MarkdownBody(
          data: visible,
          styleSheet: MarkdownStyleSheet.fromTheme(widget.theme).copyWith(
            blockquoteDecoration: BoxDecoration(
              color: widget.theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.4,
              ),
              border: Border(
                right: BorderSide(
                  color: widget.theme.colorScheme.primary,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
        if (!_completed)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 6,
              height: 18,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}
