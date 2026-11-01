import '../models/station_model.dart';

enum PassengerType { normal, senior, specialNeeds }

class FareCalculatorService {
  static int calculateMetroFare(int stationCount, PassengerType type) {
    if (type == PassengerType.specialNeeds) return 5;

    int price;
    if (stationCount <= 9) {
      price = 10;
    } else if (stationCount <= 16) {
      price = 12;
    } else if (stationCount <= 23) {
      price = 15;
    } else {
      price = 20;
    }

    return type == PassengerType.senior ? (price / 2).ceil() : price;
  }

  static int calculateMonorailFare(int stationCount, PassengerType type) {
    if (stationCount <= 0) return 0;
    if (type == PassengerType.specialNeeds) return 5;

    int price;
    if (stationCount <= 5) {
      price = 20;
    } else if (stationCount <= 10) {
      price = 40;
    } else if (stationCount <= 15) {
      price = 55;
    } else {
      price = 80;
    }

    return type == PassengerType.senior ? (price / 2).ceil() : price;
  }

  static int calculateBrtFare(int stationCount, PassengerType type) {
    if (stationCount <= 0) return 0;
    if (type == PassengerType.specialNeeds) return 5;

    int price;
    if (stationCount <= 4) {
      price = 5;
    } else if (stationCount <= 10) {
      price = 10;
    } else if (stationCount <= 14) {
      price = 15;
    } else if (stationCount <= 18) {
      price = 20;
    } else if (stationCount <= 22) {
      price = 25;
    } else if (stationCount <= 26) {
      price = 30;
    } else {
      price = 35;
    }

    return type == PassengerType.senior ? (price / 2).ceil() : price;
  }

  static int calculateTotalFare(List<Station> path, PassengerType type) {
    if (path.length <= 1) return 0;

    int metroMoves = 0;
    int monorailMoves = 0;
    int brtMoves = 0;

    for (int i = 0; i < path.length - 1; i++) {
      final cur = path[i];
      final next = path[i + 1];

      if (cur.lines.contains("BRT Ring Road") &&
          next.lines.contains("BRT Ring Road")) {
        brtMoves++;
      } else if (cur.lines.contains("Monorail East") &&
          next.lines.contains("Monorail East")) {
        monorailMoves++;
      } else {
        metroMoves++;
      }
    }

    int total = 0;
    if (metroMoves > 0) total += calculateMetroFare(metroMoves + 1, type);
    if (monorailMoves > 0) {
      total += calculateMonorailFare(monorailMoves + 1, type);
    }
    if (brtMoves > 0) total += calculateBrtFare(brtMoves + 1, type);

    return total;
  }
}
