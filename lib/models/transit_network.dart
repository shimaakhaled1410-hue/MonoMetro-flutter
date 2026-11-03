import 'package:metro/models/transit_line.dart';

enum TransitNetwork {
  rail,
  brt;

  List<TransitLine> get lines {
    return TransitLine.values.where((line) => line.network == this).toList();
  }
}