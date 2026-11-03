import 'package:get/get.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/transit_network.dart';

class Station {
  const Station({
    required this.name,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.lines,
  });

  final String name;
  final String nameAr;
  final double latitude;
  final double longitude;
  final List<TransitLine> lines;

  static final RegExp _networkSuffix = RegExp(r'\s*\([^)]*\)$');

  String get localizedName {
    final value = Get.locale?.languageCode == 'ar' ? nameAr : name;
    return network == TransitNetwork.brt
        ? value.replaceAll(_networkSuffix, '')
        : value;
  }

  TransitNetwork get network {
    return lines.isEmpty ? TransitNetwork.rail : lines.first.network;
  }

  bool get isInterchange => lines.length > 1;

  TransitLine get primaryLine => lines.first;

  bool servesMode(TransitMode mode) {
    return lines.any((line) => line.mode == mode);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Station && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
