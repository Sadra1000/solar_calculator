import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:solar_calculator/commen/constants.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/commen/widgets/error.dart';
import 'package:solar_calculator/commen/widgets/loading.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/presentation/widget/Appliance_widget.dart';
import 'package:solar_calculator/features/home/presentation/widget/selected_appliance.dart';
import 'package:solar_calculator/features/home/presentation/widget/settings_switchItem.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';
import 'package:solar_calculator/theme/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Breakpoints for responsive design

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
    return BlocListener<HomeCubit, HomeState>(
      listenWhen:
          (previous, current) =>
              (current.isLoading || current.errorMsg != null),
      listener: (context, state) async {
        if (state.isLoading) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => CustomLoading(),
          );
        } else if (state.errorMsg != null) {
          await showDialog(
            context: context,
            builder: (context) => CustomError(msg: state.errorMsg!),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.minWidth;
            if (screenWidth >= Constants.kDesktopBreakpoint) {
              // Desktop Layout (and very large tablets in landscape)
              return _buildDesktopLayout(context, (screenWidth / 200).round());
            } else if (screenWidth >= Constants.kPhoneBreakpoint) {
              // Tablet Layout (and large phones in landscape)
              return _buildTabletLayout(context, (screenWidth / 150).round());
            } else {
              return _buildTabletLayout(context, (screenWidth / 75).round());
            }
          },
        ),
      ),
    );
  }

  /// Builds the layout for desktop screens.
  Widget _buildDesktopLayout(BuildContext context, int crossAxisCount) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.isLoading) {}
      },
      child: Scaffold(
        body: Row(
          children: [
            _buildMenu(widthScaleFactor: 1.0),
            const VerticalDivider(width: 1, indent: 18, endIndent: 18),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildSelectedContainer(context),
                      _buildApplianceGrid(crossAxisCount: crossAxisCount),

                      _buildCalculateButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the layout for tablet screens.
  Widget _buildTabletLayout(BuildContext context, int crossAxisCount) {
    return Scaffold(
      appBar: AppBar(),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.large(
        tooltip: "محاسبه و نمایش نتایج",
        onPressed: () => BlocProvider.of<HomeCubit>(context).process(context),
        child: Text("محاسبه"),
      ),
      drawer: _buildMenu(widthScaleFactor: 1.1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSelectedContainer(context),

            _buildApplianceGrid(crossAxisCount: crossAxisCount),
          ],
        ),
      ),
    );
  }

  /// The results container with min height constraints.
  Widget _buildSelectedContainer(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAppliance != current.selectedAppliance,
      builder: (context, state) {
        final groups = groupAppliances(
          state.selectedAppliance.cast<Appliance>(),
        );

        if (groups.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Center(
              child: Text(
                'هیچ آیتمی انتخاب نشده است',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
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
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: GroupCard(
                      icon: IconWrapper.getMaterialIcon(icon),
                      name: label,
                      count: count,
                      totalWh: totalWh,
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

  /// The calculate button
  Widget _buildCalculateButton() {
    return SizedBox(
      height: 17.h,
      width: 30.w,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SizedBox.expand(
          // Makes the button fill the padded area
          child: FilledButton(
            onPressed: () {
              BlocProvider.of<HomeCubit>(context).process(context);
            },
            child: Text(
              'محاسبه کن',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A reusable GridView builder for appliances.
  Widget _buildApplianceGrid({required int crossAxisCount}) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) => previous.initialList != current.initialList,
      builder: (context, state) {
        final itemHeight = 23.h;
        final verticalSpacing = 2.h;
        final totalHeight =
            (itemHeight *
                ((state.initialList.length / crossAxisCount).ceil() -
                    (crossAxisCount / 10).ceil())) +
            (verticalSpacing *
                (((state.initialList.length / crossAxisCount).ceil()) - 1));
        return SizedBox(
          height: totalHeight,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: verticalSpacing,
              crossAxisSpacing: 2.w, // فاصله ستون‌ها
              childAspectRatio: 1, // نسبت ابعاد آیتم
            ),
            itemCount: state.initialList.length,
            itemBuilder: (context, index) {
              final appliance = state.initialList[index];
              return ApplianceIcon(catgory: appliance);
            },
          ),
        );
      },
    );
  }

  /// The settings menu, used as a permanent panel or a drawer.
  Widget _buildMenu({required double widthScaleFactor}) {
    return Drawer(
      width: 350 * widthScaleFactor,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen:
            (previous, current) =>
                (previous.aiprocessing != current.aiprocessing ||
                    previous.ecoprocessing != current.ecoprocessing ||
                    previous.envirprocessing != current.ecoprocessing),
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero, // Remove default padding
                  children: [
                    SizedBox(
                      height: 50 * widthScaleFactor,
                    ), // Give some space at top
                    Center(
                      child: Text(
                        'ماشین حساب خورشیدی',
                        style: TextStyle(
                          fontSize: 20 * widthScaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SettingsSwitchItem(
                      icon: Icons.smart_toy_outlined,
                      title: 'تحلیل AI',
                      scalefactor: widthScaleFactor,
                      value: state.aiprocessing,
                      onChanged: (val) {
                        context.read<HomeCubit>().toggleAIProcessing(val);
                      },
                    ),
                    SettingsSwitchItem(
                      scalefactor: widthScaleFactor,
                      icon: Icons.diamond_sharp,
                      title: 'تحلیل اقتصادی',
                      value: state.ecoprocessing,
                      onChanged: (val) {
                        context.read<HomeCubit>().toggleEcoProcessing(val);
                      },
                    ),
                    SettingsSwitchItem(
                      icon: Icons.energy_savings_leaf_sharp,
                      title: 'تحلیل زیست محیطی',
                      scalefactor: widthScaleFactor,
                      value: state.envirprocessing,
                      onChanged: (val) {
                        context.read<HomeCubit>().toggleEnvirProcessing(val);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<ThemeCubit>().changeThemeMode();
                  },
                  child: AnimatedSwitcher(
                    duration: Durations.long4,
                    transitionBuilder:
                        (child, animation) =>
                            RotationTransition(turns: animation, child: child),
                    child:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Icon(
                              Icons.dark_mode,
                              key: ValueKey('dark_mode'),
                              color: Colors.blueGrey,
                            )
                            : const Icon(
                              Icons.light_mode,
                              key: ValueKey('light_mode'),
                              color: Colors.amber,
                            ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int totalGroupWh(List<Appliance> group) {
    if (group.isEmpty) return 0;
    // توان هر آیتم = powerUsage * hours
    // خروجی به صورت W/h تجمیع می‌شود
    // چون powerUsage:int و hours:double است، جمع را به int رُند می‌کنیم
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
