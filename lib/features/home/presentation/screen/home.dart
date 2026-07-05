import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_calculator/commen/helpers/api_errors.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/commen/platform/navigate_back.dart';
import 'package:solar_calculator/commen/widgets/error.dart';
import 'package:solar_calculator/commen/widgets/loading.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/presentation/widget/appliance_widget.dart';
import 'package:solar_calculator/features/home/presentation/widget/selected_appliance.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).initialList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textDirection =
        Localizations.localeOf(context).languageCode == 'fa'
            ? TextDirection.rtl
            : TextDirection.ltr;

    return BlocListener<HomeCubit, HomeState>(
      listenWhen:
          (previous, current) =>
              (current.isLoading || current.errorMsg != null),
      listener: (context, state) async {
        if (state.isLoading) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const CustomLoading(),
          );
        } else if (state.errorMsg != null) {
          await showDialog(
            context: context,
            builder: (dialogContext) {
              final errorL10n = AppLocalizations.of(dialogContext)!;
              return CustomError(
                msg: localizeApiError(errorL10n, state.errorMsg!),
              );
            },
          );
        }
      },
      child: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.appTitle),
            centerTitle: true,
            actions: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: BackButton(onPressed: navigateBack),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final content = isLargeScreen(constraints.maxWidth)
                  ? _buildLargeScreenBody(constraints.maxWidth)
                  : _buildSmallScreenBody(constraints.maxWidth);

              return constrainContent(child: content);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSmallScreenBody(double maxWidth) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSelectedContainer(maxWidth),
        _buildApplianceGrid(maxWidth),
        _buildCalculateButton(),
      ],
    );
  }

  Widget _buildLargeScreenBody(double maxWidth) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildSelectedContainer(maxWidth),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 7,
              child: _buildApplianceGrid(maxWidth),
            ),
          ],
        ),
        _buildCalculateButton(),
      ],
    );
  }

  Widget _buildSelectedContainer(double maxWidth) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAppliance != current.selectedAppliance,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final groups = groupAppliances(
          state.selectedAppliance.cast<Appliance>(),
        );

        if (groups.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                l10n.noItemsSelected,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children:
                groups.entries.map((entry) {
                  final label = entry.key;
                  final list = entry.value;
                  final count = list.length;
                  final icon = list.first.icon;
                  final totalWh = totalGroupWh(list);
                  final sample = list.first;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GroupCard(
                      icon: IconWrapper.getMaterialIcon(icon),
                      name: label,
                      count: count,
                      totalWh: totalWh,
                      maxWidth: maxWidth,
                      onAdd: () => context.read<HomeCubit>().addOneLike(sample),
                      onRemoveOne:
                          () => context
                              .read<HomeCubit>()
                              .removeOneApplianceOfType(label),
                      onRemoveAll:
                          () => context
                              .read<HomeCubit>()
                              .removeAllApplianceOfType(label),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCalculateButton() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            BlocProvider.of<HomeCubit>(context).process(context);
          },
          child: Text(
            l10n.calculate,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildApplianceGrid(double maxWidth) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) => previous.initialList != current.initialList,
      builder: (context, state) {
        final itemSize = adaptiveGridItemSize(maxWidth);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: List.generate(state.initialList.length, (index) {
              final appliance = state.initialList[index];
              return SizedBox(
                width: itemSize,
                height: itemSize,
                child: ApplianceIcon(catgory: appliance),
              );
            }),
          ),
        );
      },
    );
  }

  int totalGroupWh(List<Appliance> group) {
    if (group.isEmpty) return 0;
    final perItem = (group.first.powerUsage * group.first.houres).round();
    return perItem * group.length;
  }

  Map<String, List<Appliance>> groupAppliances(List<Appliance> items) {
    final map = <String, List<Appliance>>{};
    for (final a in items) {
      map.putIfAbsent(a.key, () => []).add(a);
    }
    return map;
  }
}
