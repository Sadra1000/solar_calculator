import 'package:flutter/material.dart';

/// کلاس wrapper برای مدیریت آیکون‌های مختلف وسایل برقی خانگی
class IconWrapper {
  /// دریافت آیکون Material بر اساس شماره آیکون
  static IconData getMaterialIcon(int iconId) {
    switch (iconId) {
      case 1:
        return Icons.tv;
      case 2:
        return Icons.local_laundry_service;
      case 3:
        return Icons.kitchen;
      case 4:
        return Icons.ac_unit;
      case 5:
        return Icons.cleaning_services;
      case 6:
        return Icons.ac_unit;
      case 7:
        return Icons.opacity;
      case 8:
        return Icons.air_sharp;
      case 9:
        return Icons.light;
      case 10:
        return Icons.videogame_asset;
      case 11:
        return Icons.thermostat;
      case 12:
        return Icons.water;
      case 13:
        return Icons.app_shortcut_outlined;
      case 14:
        return Icons.microwave;
      case 15:
        return Icons.router;
      case 16:
        return Icons.rice_bowl;
      case 17:
        return Icons.blender;
      case 18:
        return Icons.coffee_maker;
      case 19:
        return Icons.local_cafe;
      case 20:
        return Icons.bakery_dining;
      case 21:
        return Icons.fastfood;
      case 22:
        return Icons.kebab_dining;
      case 23:
        return Icons.lunch_dining;
      case 24:
        return Icons.blender_outlined;
      case 25:
        return Icons.iron;
      case 26:
        return Icons.air;
      case 27:
        return Icons.device_thermostat_outlined;
      case 28:
        return Icons.adf_scanner_outlined;

      default:
        return Icons.help_outline;
    }
  }

  static Map<IconData, int> iconToId = {
    Icons.tv: 1,
    Icons.local_laundry_service: 2,
    Icons.kitchen: 3,
    Icons.ac_unit: 4, // 6 هم ac_unit است؛ 4 را معیار گرفتیم
    Icons.cleaning_services: 5,
    Icons.opacity: 7,
    Icons.air_sharp: 8,
    Icons.light: 9, // اگر خطا داشت: Icons.lightbulb
    Icons.videogame_asset: 10,
    Icons.thermostat: 11,
    Icons.water: 12,
    Icons.app_shortcut_outlined: 13,
    Icons.microwave: 14,
    Icons.router: 15,
    Icons.rice_bowl: 16,
    Icons.blender: 17,
    Icons.coffee_maker: 18,
    Icons.local_cafe: 19,
    Icons.bakery_dining: 20,
    Icons.fastfood: 21,
    Icons.kebab_dining: 22,
    Icons.lunch_dining: 23,
    Icons.blender_outlined: 24,
    Icons.iron: 25,
    Icons.air: 26,
    Icons.device_thermostat_outlined: 27,
    Icons.adf_scanner_outlined: 28,
  };
}
