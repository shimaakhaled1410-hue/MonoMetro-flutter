import 'package:get/get.dart';

String _two(int value) => value.toString().padLeft(2, '0');

/// 12-hour clock with an AM/PM marker (ص/م in Arabic), e.g. "10:58 AM".
String formatClock(DateTime date) {
  final isAr = Get.locale?.languageCode == 'ar';
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final isPm = date.hour >= 12;
  final marker = isAr ? (isPm ? 'م' : 'ص') : (isPm ? 'PM' : 'AM');
  return '$hour:${_two(date.minute)} $marker';
}

String formatDay(DateTime date) {
  return '${_two(date.day)}/${_two(date.month)}/${date.year}';
}

/// "Today", "Yesterday", or a dd/MM/yyyy date.
String dayLabel(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final dayOnly = DateTime(date.year, date.month, date.day);
  final todayOnly = DateTime(today.year, today.month, today.day);
  final difference = todayOnly.difference(dayOnly).inDays;
  if (difference == 0) return 'today'.tr;
  if (difference == 1) return 'yesterday'.tr;
  return formatDay(date);
}
