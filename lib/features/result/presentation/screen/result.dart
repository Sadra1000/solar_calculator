import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/features/result/repository/model.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'dart:async';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = (ModalRoute.of(context)!.settings.arguments) as ResulteModel;
    final l10n = AppLocalizations.of(context)!;
    final textDirection =
        Localizations.localeOf(context).languageCode == 'fa'
            ? TextDirection.rtl
            : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.resultsTitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final content = isLargeScreen(constraints.maxWidth)
                ? _buildLargeScreenLayout(context, data: data)
                : _buildSmallScreenLayout(context, data: data);

            return constrainContent(
              maxWidth: AppBreakpoints.resultContentMaxWidth,
              child: content,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmallScreenLayout(
    BuildContext context, {
    required ResulteModel data,
  }) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AnalysisPanel(markdown: data.analysis, theme: theme),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildListOfCalculatedItems(
                context: context,
                dailyConsumption: data.dailyConsumption.toStringAsFixed(2),
                monthlyConsumption: data.monthlyConsumption.toStringAsFixed(2),
                yearlyConsumption: data.yearlyConsumption.toStringAsFixed(2),
                yearlyCo2Production: data.yearlyCo2Production.toStringAsFixed(
                  2,
                ),
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
  }) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AnalysisPanel(
            markdown: data.analysis,
            theme: theme,
            isLargeScreen: true,
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
                    dailyConsumption: data.dailyConsumption.toStringAsFixed(2),
                    monthlyConsumption: data.monthlyConsumption
                        .toStringAsFixed(2),
                    yearlyConsumption: data.yearlyConsumption.toStringAsFixed(
                      2,
                    ),
                    yearlyCo2Production: data.yearlyCo2Production
                        .toStringAsFixed(2),
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
    required String dailyConsumption,
    required String monthlyConsumption,
    required String yearlyConsumption,
    required String yearlyCo2Production,
    required Locale locale,
    required ThemeData theme,
    bool isLargeScreen = false,
    double? tileWidth,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      (l10n.dailyConsumption, dailyConsumption.tokWhPersian(locale)),
      (l10n.monthlyConsumption, monthlyConsumption.tokWhPersian(locale)),
      (l10n.yearlyConsumption, yearlyConsumption.tokWhPersian(locale)),
      (l10n.yearlyCo2Production, yearlyCo2Production.tokWhPersian(locale)),
    ];

    return List.generate(items.length, (index) {
      final item = items[index];
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: _buildResultTile(
              theme: theme,
              title: item.$1,
              value: item.$2,
              isLargeScreen: isLargeScreen,
              width: tileWidth,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResultTile({
    required String title,
    required String value,
    required bool isLargeScreen,
    required ThemeData theme,
    double? width,
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
          ],
        )
        : Row(
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
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: theme.colorScheme.primary),
        color: theme.colorScheme.tertiaryContainer,
      ),
      height: isLargeScreen ? 140 : 72,
      width: isLargeScreen ? width : double.infinity,
      child: content,
    );
  }
}

class _AnalysisPanel extends StatelessWidget {
  final String markdown;
  final ThemeData theme;
  final bool isLargeScreen;

  const _AnalysisPanel({
    required this.markdown,
    required this.theme,
    this.isLargeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.5,
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: _AnimatedMarkdownTyper(
        markdown: markdown,
        theme: theme,
        speed: const Duration(milliseconds: 18),
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
              color: widget.theme.colorScheme.secondaryContainer.withOpacity(
                0.4,
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
