import 'package:get/get.dart';

String _two(int value) => value.toString().padLeft(2, '0');

String formatClock(DateTime date) => '${_two(date.hour)}:${_two(date.minute)}';

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
