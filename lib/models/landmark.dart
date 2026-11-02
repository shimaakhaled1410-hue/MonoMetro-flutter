import 'package:get/get.dart';

class Landmark {
  const Landmark({
    required this.titleEn,
    required this.titleAr,
    required this.stationName,
  });

  final String titleEn;
  final String titleAr;
  final String stationName;

  String get localizedTitle {
    return Get.locale?.languageCode == 'ar' ? titleAr : titleEn;
  }
}
