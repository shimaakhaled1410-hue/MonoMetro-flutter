import 'package:get/get.dart';
import 'package:metro/core/localization/translations_ar.dart';
import 'package:metro/core/localization/translations_en.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': translationsEn,
        'ar_EG': translationsAr,
      };
}
