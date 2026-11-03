import 'package:metro/models/transit_mode.dart';

class FareTier {
  const FareTier(this.maxStations, this.price);

  final int maxStations;
  final int price;
}

class FareData {
  const FareData._();

  static const int specialNeedsFare = 5;
  static const int unlimited = 9999;

  static const Map<TransitMode, List<FareTier>> tiers = {
    TransitMode.metro: [
      FareTier(9, 10),
      FareTier(16, 12),
      FareTier(23, 15),
      FareTier(unlimited, 20),
    ],
    TransitMode.monorail: [
      FareTier(5, 20),
      FareTier(10, 40),
      FareTier(15, 55),
      FareTier(unlimited, 80),
    ],
  };
}
