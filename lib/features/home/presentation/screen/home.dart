import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:solar_calculator/commen/helpers/icon_helper.dart';
import 'package:solar_calculator/commen/widgets/error.dart';
import 'package:solar_calculator/commen/widgets/loading.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:solar_calculator/features/home/presentation/cubit/home/home_state.dart';
import 'package:solar_calculator/features/home/presentation/widget/Appliance_widget.dart';
import 'package:solar_calculator/features/home/presentation/widget/selected_appliance.dart';
import 'package:solar_calculator/features/home/model/appliances.dart';

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
        child: Scaffold(
          body: Column(
            children: [
              _buildSelectedContainer(context),
              _buildApplianceGrid(),
              _buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

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
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
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

  Widget _buildCalculateButton() {
    return SizedBox(
      height: 1.h > 1.w ? 12.h : 15.h,
      width: 1.h > 1.w ? 25.w : 20.w,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SizedBox.expand(
          // Makes the button fill the padded area
          child: FilledButton(
            onPressed: () {
              BlocProvider.of<HomeCubit>(context).process(context);
            },
            child: Text(
              'حساب کن!',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplianceGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) => previous.initialList != current.initialList,
      builder: (context, state) {
        return Wrap(
          spacing: 1.h > 1.w ? 1.h : 1.w,
          runSpacing: 1.h > 1.w ? 1.h : 1.w,
          children: List.generate(state.initialList.length, (index) {
            final appliance = state.initialList[index];
            return ApplianceIcon(catgory: appliance);
          }),
        );
      },
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
