import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';
import 'package:solar_calculator/commen/constants.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/features/result/repository/model.dart';
import 'dart:async';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // دریافت دیتا از Route Arguments
    final data = (ModalRoute.of(context)!.settings.arguments) as ResulteModel;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'نتایج محاسبه',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= Constants.kDesktopBreakpoint) {
              return _buildDesktopLayout(context, data: data);
            } else if (constraints.maxWidth >= Constants.kPhoneBreakpoint) {
              return _buildDesktopLayout(context, data: data);
            } else {
              return _buildMobileLayout(context, data: data);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context, {
    required ResulteModel data,
  }) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AnalysisPanel(markdown: data.analysis, theme: theme),
          SizedBox(height: 10.sp),
          AnimationLimiter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _builListOfCalculatedItems(
                dailyConsumption: data.dailyConsumption.toStringAsFixed(2),
                monthlyConsumption: data.monthlyConsumption.toStringAsFixed(2),
                yearlyConsumption: data.dailyConsumption.toStringAsFixed(2),
                yearlyCo2Production: data.yearlyCo2Production.toStringAsFixed(
                  2,
                ),
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context, {
    required ResulteModel data,
  }) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AnalysisPanel(
            markdown: data.analysis,
            theme: theme,
            isDesktop: true,
          ),
          SizedBox(height: 12.sp),
          AnimationLimiter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _builListOfCalculatedItems(
                dailyConsumption: data.dailyConsumption.toStringAsFixed(2),
                monthlyConsumption: data.monthlyConsumption.toStringAsFixed(2),
                yearlyConsumption: data.dailyConsumption.toStringAsFixed(2),
                yearlyCo2Production: data.yearlyCo2Production.toStringAsFixed(
                  2,
                ),
                isDesktop: true,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _builListOfCalculatedItems({
    required String dailyConsumption,
    required String monthlyConsumption,
    required String yearlyConsumption,
    required String yearlyCo2Production,
    bool isDesktop = false,
    required ThemeData theme,
  }) {
    return [
      AnimationConfiguration.staggeredList(
        position: 0,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: IntrinsicWidth(
              // برای اینکه عرض آیتم‌ها متناسب با محتوا باشد
              child: _buildResultTile(
                theme: theme,
                title: " مصرف روزانه:",
                value: dailyConsumption.tokWhPersian(),
                isDesktop: isDesktop,
              ),
            ),
          ),
        ),
      ),
      AnimationConfiguration.staggeredList(
        position: 1,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: IntrinsicWidth(
              child: _buildResultTile(
                theme: theme,
                title: " مصرف ماهانه:",
                value: monthlyConsumption.tokWhPersian(),
                isDesktop: isDesktop,
              ),
            ),
          ),
        ),
      ),
      AnimationConfiguration.staggeredList(
        position: 2,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: IntrinsicWidth(
              child: _buildResultTile(
                theme: theme,
                title: " مصرف سالانه:",
                value: yearlyConsumption.tokWhPersian(),
                isDesktop: isDesktop,
              ),
            ),
          ),
        ),
      ),
      AnimationConfiguration.staggeredList(
        position: 3,
        duration: const Duration(milliseconds: 400),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: IntrinsicWidth(
              // برای اینکه عرض آیتم‌ها متناسب با محتوا باشد
              child: _buildResultTile(
                theme: theme,
                title: " تولید CO2 سالانه:",
                value: yearlyCo2Production.tokWhPersian(),
                isDesktop: isDesktop,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildResultTile({
    required String title,
    required String value,
    required bool isDesktop,
    required ThemeData theme,
  }) {
    Widget content =
        isDesktop
            ? Column(
              // حالت دسکتاپ: عنوان بالا، مقدار پایین
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
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
              // حالت موبایل/تبلت
              children: [
                Expanded(
                  flex: 24,
                  child: Text(title, textAlign: TextAlign.right),
                ),
                const Spacer(),
                Expanded(
                  flex: 30,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: theme.colorScheme.primary),
        color: theme.colorScheme.tertiaryContainer,
      ),
      // در حالت دسکتاپ برای هم‌اندازه شدن، ارتفاع مشخصی می‌دهیم
      height: isDesktop ? 20.h : 10.h,
      width: isDesktop ? null : 100.w,
      child: content,
    );
  }
}

class _AnalysisPanel extends StatelessWidget {
  final String markdown;
  final ThemeData theme;
  final bool isDesktop;
  const _AnalysisPanel({
    required this.markdown,
    required this.theme,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
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
        setState(() => _len += 2); // نمایش 2 کاراکتر در هر تیک
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
