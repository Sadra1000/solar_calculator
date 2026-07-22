class PresetApplianceRef {
  const PresetApplianceRef({required this.id, this.hours});

  final String id;
  final double? hours;
}

class PresetProfile {
  const PresetProfile({
    required this.id,
    required this.nameFa,
    required this.nameEn,
    required this.appliances,
  });

  final String id;
  final String nameFa;
  final String nameEn;
  final List<PresetApplianceRef> appliances;

  String localizedName(String languageCode) =>
      languageCode == 'fa' ? nameFa : nameEn;
}

const List<PresetProfile> presetProfiles = [
  PresetProfile(
    id: 'home_3',
    nameFa: 'خانه ۳ نفره',
    nameEn: '3-person home',
    appliances: [
      PresetApplianceRef(id: 'cat_3_medium_fridge_9_cu_ft_1', hours: 24),
      PresetApplianceRef(id: 'cat_1_43_led_tv_1', hours: 6),
      PresetApplianceRef(id: 'cat_9_led_bulb_0', hours: 5),
      PresetApplianceRef(id: 'cat_2_medium_washer_7_kg_1', hours: 1),
      PresetApplianceRef(id: 'cat_4_12000_btu_ac_1', hours: 8),
    ],
  ),
  PresetProfile(
    id: 'apt_small',
    nameFa: 'آپارتمان کوچک',
    nameEn: 'Small apartment',
    appliances: [
      PresetApplianceRef(id: 'cat_3_small_fridge_3_cu_ft_0', hours: 24),
      PresetApplianceRef(id: 'cat_1_32_led_tv_0', hours: 4),
      PresetApplianceRef(id: 'cat_9_led_bulb_0', hours: 4),
      PresetApplianceRef(id: 'cat_5_medium_vacuum_1', hours: 0.5),
    ],
  ),
  PresetProfile(
    id: 'office',
    nameFa: 'دفتر کار',
    nameEn: 'Office',
    appliances: [
      PresetApplianceRef(id: 'cat_9_led_tube_light_2', hours: 10),
      PresetApplianceRef(id: 'cat_4_18000_btu_ac_2', hours: 8),
      PresetApplianceRef(id: 'cat_3_small_fridge_3_cu_ft_0', hours: 24),
    ],
  ),
];
