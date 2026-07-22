import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_calculator/commen/helpers/api_errors.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/commen/helpers/persian.dart';
import 'package:solar_calculator/commen/layout/responsive.dart';
import 'package:solar_calculator/commen/platform/navigate_back.dart';
import 'package:solar_calculator/commen/widgets/error.dart';
import 'package:solar_calculator/commen/widgets/loading.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/features/home/model/preset_profiles.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/presentation/widget/appliance_widget.dart';
import 'package:solar_calculator/features/home/presentation/widget/selected_appliance.dart';
import 'package:solar_calculator/features/solar/iran_cities.dart';
import 'package:solar_calculator/l10n/app_localizations.dart';
import 'package:solar_calculator/theme/locale_cubit.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingDialogOpen = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).initialList();
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
              previous.isLoading != current.isLoading ||
              previous.errorMsg != current.errorMsg ||
              previous.navigationEvent != current.navigationEvent,
      listener: (context, state) async {
        if (state.isLoading && !_loadingDialogOpen) {
          _loadingDialogOpen = true;
          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) => const CustomLoading(),
          );
        } else if (!state.isLoading && _loadingDialogOpen) {
          Navigator.of(context, rootNavigator: true).pop();
          _loadingDialogOpen = false;
        }

        if (!context.mounted) return;

        final event = state.navigationEvent;
        if (event != null) {
          final cubit = context.read<HomeCubit>();
          cubit.clearNavigationEvent();
          if (context.mounted) {
            await context.push('/result', extra: event.session);
          }
        }

        if (state.errorMsg != null) {
          if (!context.mounted) return;
          final cubit = context.read<HomeCubit>();
          final languageCode = Localizations.localeOf(context).languageCode;
          await showDialog<void>(
            context: context,
            builder: (dialogContext) {
              final errorL10n = AppLocalizations.of(dialogContext)!;
              return CustomError(
                msg: localizeApiError(errorL10n, state.errorMsg!),
                onDismiss: () {
                  Navigator.of(dialogContext).pop();
                  cubit.clearError();
                },
                onRetry:
                    state.aiprocessing
                        ? () {
                          Navigator.of(dialogContext).pop();
                          cubit.clearError();
                          cubit.process(languageCode: languageCode);
                        }
                        : null,
              );
            },
          );
          if (context.mounted) {
            cubit.clearError();
          }
        }
      },
      child: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.appTitle),
            centerTitle: true,
            actions: [
              BlocBuilder<ThemeCubit, bool>(
                builder: (context, isDark) {
                  return IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    tooltip: l10n.themeToggle,
                    onPressed:
                        () => context.read<ThemeCubit>().changeThemeMode(),
                  );
                },
              ),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return IconButton(
                    tooltip: l10n.languageToggle,
                    onPressed: () => context.read<LocaleCubit>().toggleLocale(),
                    icon: Text(
                      locale.languageCode == 'fa' ? 'EN' : 'فا',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: l10n.historyTitle,
                onPressed: () => context.push('/history'),
              ),
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
        _buildOptionsSection(),
        _buildSelectedContainer(maxWidth),
        _buildApplianceGrid(maxWidth),
        _buildAiToggle(),
        _buildConsumptionSummary(),
        _buildCalculateButton(),
      ],
    );
  }

  Widget _buildLargeScreenBody(double maxWidth) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildOptionsSection(),
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
        _buildAiToggle(),
        _buildConsumptionSummary(),
        _buildCalculateButton(),
      ],
    );
  }

  Widget _buildAiToggle() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.aiprocessing != current.aiprocessing,
      builder: (context, state) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.enableAiAnalysis),
          value: state.aiprocessing,
          onChanged: context.read<HomeCubit>().toggleAIProcessing,
        );
      },
    );
  }

  Widget _buildConsumptionSummary() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAppliance != current.selectedAppliance,
      builder: (context, state) {
        if (state.selectedAppliance.isEmpty) {
          return const SizedBox.shrink();
        }

        final l10n = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        final dailyKwh = context.read<HomeCubit>().totalDailyKwh;
        final value =
            dailyKwh < 1
                ? (dailyKwh * 1000).toStringAsFixed(0).toWhPersian(locale)
                : dailyKwh.toStringAsFixed(2).tokWhPersian(locale);

        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            l10n.liveDailyConsumption(value),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildOptionsSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedCityId != current.selectedCityId ||
              previous.electricityRateToman != current.electricityRateToman,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        final cubit = context.read<HomeCubit>();

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.presetsTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    presetProfiles.map((preset) {
                      return ActionChip(
                        label: Text(preset.localizedName(locale.languageCode)),
                        onPressed: () => cubit.applyPreset(preset),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(state.selectedCityId),
                initialValue: state.selectedCityId,
                decoration: InputDecoration(
                  labelText: l10n.selectCity,
                  border: const OutlineInputBorder(),
                ),
                items:
                    iranCities.map((city) {
                      return DropdownMenuItem(
                        value: city.id,
                        child: Text(city.localizedName(locale.languageCode)),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) cubit.setSelectedCity(value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: state.electricityRateToman.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.electricityRate,
                  border: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  final rate = double.tryParse(value);
                  if (rate != null && rate > 0) {
                    cubit.setElectricityRate(rate);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedContainer(double maxWidth) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAppliance != current.selectedAppliance,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        final languageCode = locale.languageCode;
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
                  final id = entry.key;
                  final list = entry.value;
                  final count = list.length;
                  final icon = list.first.icon;
                  final totalWh = totalGroupWh(list);
                  final sample = list.first;
                  final displayName = sample.localizedName(languageCode);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GroupCard(
                      icon: IconWrapper.getMaterialIcon(icon),
                      name: displayName,
                      count: count,
                      totalWh: totalWh,
                      maxWidth: maxWidth,
                      onAdd: () => context.read<HomeCubit>().addOneLike(sample),
                      onRemoveOne:
                          () => context
                              .read<HomeCubit>()
                              .removeOneApplianceOfType(id),
                      onRemoveAll:
                          () => context
                              .read<HomeCubit>()
                              .removeAllApplianceOfType(id),
                      onEditHours:
                          () => _showEditHoursDialog(context, sample),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showEditHoursDialog(BuildContext context, Appliance appliance) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    double selectedHours = appliance.houres;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                l10n.operatingHours(appliance.localizedName(languageCode)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.hoursPrompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.hoursValue(
                      selectedHours
                          .toStringAsFixed(1)
                          .localizedDigits(locale),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Slider(
                    value: selectedHours,
                    min: 0.0,
                    max: 24.0,
                    divisions: 96,
                    label: selectedHours.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => selectedHours = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.dismiss),
                ),
                FilledButton(
                  onPressed: () {
                    context.read<HomeCubit>().updateGroupHours(
                      appliance.id,
                      selectedHours,
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCalculateButton() {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAppliance != current.selectedAppliance,
      builder: (context, state) {
        final hasSelection = state.selectedAppliance.isNotEmpty;
        final languageCode = Localizations.localeOf(context).languageCode;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasSelection)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.selectAppliancesToCalculate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      hasSelection
                          ? () => context.read<HomeCubit>().process(
                            languageCode: languageCode,
                          )
                          : null,
                  child: Text(
                    l10n.calculate,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApplianceGrid(double maxWidth) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.initialList != current.initialList ||
              previous.applianceSearchQuery != current.applianceSearchQuery,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final itemSize = adaptiveGridItemSize(maxWidth);
        final query = state.applianceSearchQuery.trim().toLowerCase();
        final languageCode = Localizations.localeOf(context).languageCode;
        final filtered =
            state.initialList.where((cat) {
              if (query.isEmpty) return true;
              if (cat.localizedName(languageCode).toLowerCase().contains(query)) {
                return true;
              }
              if (cat.nameFa.toLowerCase().contains(query)) return true;
              if (cat.nameEn.toLowerCase().contains(query)) return true;
              return cat.appliances.any(
                (a) =>
                    a.localizedName(languageCode).toLowerCase().contains(query) ||
                    a.nameFa.toLowerCase().contains(query) ||
                    a.nameEn.toLowerCase().contains(query),
              );
            }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchAppliances,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged:
                    (value) => context.read<HomeCubit>().setApplianceSearchQuery(
                      value,
                    ),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.noSearchResults),
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children:
                      filtered.map((appliance) {
                        return SizedBox(
                          width: itemSize,
                          height: itemSize,
                          child: ApplianceIcon(category: appliance),
                        );
                      }).toList(),
                ),
            ],
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
    final sorted =
        map.entries.toList()
          ..sort(
            (a, b) => totalGroupWh(b.value).compareTo(totalGroupWh(a.value)),
          );
    return Map.fromEntries(sorted);
  }
}
