import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/transit_network.dart';

enum TransitLine {
  line1(mode: TransitMode.metro, labelKey: 'line_1'),
  line2(mode: TransitMode.metro, labelKey: 'line_2'),
  line3(mode: TransitMode.metro, labelKey: 'line_3'),
  monorailEast(mode: TransitMode.monorail, labelKey: 'monorail_line'),
  brtRing(mode: TransitMode.brt, labelKey: 'brt_line');

  const TransitLine({required this.mode, required this.labelKey});

  final TransitMode mode;
  final String labelKey;

  TransitNetwork get network {
    return mode == TransitMode.brt ? TransitNetwork.brt : TransitNetwork.rail;
  }
}
