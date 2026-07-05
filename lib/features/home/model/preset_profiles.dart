class PresetApplianceRef {
  const PresetApplianceRef({required this.name, this.hours});

  final String name;
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
      PresetApplianceRef(name: 'یخچال متوسط (9 فوت)', hours: 24),
      PresetApplianceRef(name: 'تلویزیون LED 43 اینچ', hours: 6),
      PresetApplianceRef(name: 'لامپ ال‌ای‌دی (LED)', hours: 5),
      PresetApplianceRef(name: 'ماشین لباسشویی متوسط (7 کیلو)', hours: 1),
      PresetApplianceRef(name: 'کولر گازی 12000 BTU', hours: 8),
    ],
  ),
  PresetProfile(
    id: 'apt_small',
    nameFa: 'آپارتمان کوچک',
    nameEn: 'Small apartment',
    appliances: [
      PresetApplianceRef(name: 'یخچال کوچک (3 فوت)', hours: 24),
      PresetApplianceRef(name: 'تلویزیون LED 32 اینچ', hours: 4),
      PresetApplianceRef(name: 'لامپ ال‌ای‌دی (LED)', hours: 4),
      PresetApplianceRef(name: 'جاروبرقی متوسط', hours: 0.5),
    ],
  ),
  PresetProfile(
    id: 'office',
    nameFa: 'دفتر کار',
    nameEn: 'Office',
    appliances: [
      PresetApplianceRef(name: 'لامپ مهتابی LED', hours: 10),
      PresetApplianceRef(name: 'کولر گازی 18000 BTU', hours: 8),
      PresetApplianceRef(name: 'یخچال کوچک (3 فوت)', hours: 24),
    ],
  ),
];
