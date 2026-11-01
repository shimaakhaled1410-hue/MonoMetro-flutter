import 'dart:collection';
import '../data/metro_data.dart';
import '../models/station_model.dart';
import 'fare_calculator_service.dart';
import 'route_instructions_service.dart';

export 'fare_calculator_service.dart' show PassengerType;

class MetroGraphService {
  final Map<String, List<String>> _adjacencyList = {};

  MetroGraphService() {
    _buildGraph();
  }

  void _buildGraph() {
    _addBidirectionalEdges(MetroData.line1Names);
    _addBidirectionalEdges(MetroData.line2Names);
    _addBidirectionalEdges(MetroData.line3Common);
    _addBidirectionalEdges(MetroData.line3BranchA);
    _addBidirectionalEdges(MetroData.line3BranchB);
    _addBidirectionalEdges(MetroData.monorailEastNames);
    _addBidirectionalEdges(MetroData.brtRingRoadNames);

    if (MetroData.brtRingRoadNames.isNotEmpty) {
      _addEdge(MetroData.brtRingRoadNames.first, MetroData.brtRingRoadNames.last);
      _addEdge(MetroData.brtRingRoadNames.last, MetroData.brtRingRoadNames.first);
    }

    _addTransfer("Kit Kat", ["El-Tawfiqiya", "Sudan"]);
    _addTransfer("Adly Mansour", ["El Haykestep"]);
    _addTransfer("Stadium", ["Stadium (Monorail)"]);
  }

  void _addBidirectionalEdges(List<String> stations) {
    for (int i = 0; i < stations.length - 1; i++) {
      _addEdge(stations[i], stations[i + 1]);
      _addEdge(stations[i + 1], stations[i]);
    }
  }

  void _addEdge(String u, String v) {
    _adjacencyList.putIfAbsent(u, () => []);
    if (!_adjacencyList[u]!.contains(v)) _adjacencyList[u]!.add(v);
  }

  void _addTransfer(String station, List<String> branches) {
    for (var b in branches) {
      _addEdge(station, b);
      _addEdge(b, station);
    }
  }

  Station? getStationByName(String name) {
    final cleanSearch = name.trim().toLowerCase().replaceAll('-', ' ').replaceAll('el ', '').replaceAll('al ', '');
    try {
      return MetroData.allStations.firstWhere((s) {
        final clean = s.name.trim().toLowerCase().replaceAll('-', ' ').replaceAll('el ', '').replaceAll('al ', '');
        return clean == cleanSearch || s.name.toLowerCase() == name.trim().toLowerCase();
      });
    } catch (_) {
      return null;
    }
  }

  int countTransfers(List<String> path) {
    if (path.length < 2) return 0;
    int transfers = 0;
    String curLine = RouteInstructionsService.getCommonLine(getStationByName(path[0]), getStationByName(path[1]));

    for (int i = 1; i < path.length - 1; i++) {
      String nextLine = RouteInstructionsService.getCommonLine(getStationByName(path[i]), getStationByName(path[i + 1]));
      if (curLine != nextLine && nextLine.isNotEmpty && curLine.isNotEmpty) {
        transfers++;
        curLine = nextLine;
      }
    }
    return transfers;
  }

  TripResult? calculateTrip(String start, String end, PassengerType passengerType, {bool preferFewerTransfers = false}) {
    if (start == end) {
      final s = getStationByName(start);
      if (s == null) return null;
      return TripResult(
        path: [s],
        stationCount: 1,
        estimatedTimeMinutes: 0,
        ticketPrice: FareCalculatorService.calculateTotalFare([s], passengerType),
        instructions: ['You are already at the destination'],
        transferCount: 0,
      );
    }

    List<List<String>> allPaths = [];
    Queue<List<String>> queue = Queue()..add([start]);

    while (queue.isNotEmpty && allPaths.length < 25) {
      List<String> current = queue.removeFirst();
      String last = current.last;

      if (last == end) {
        allPaths.add(current);
        continue;
      }

      for (String neighbor in _adjacencyList[last] ?? []) {
        if (!current.contains(neighbor) && current.length <= 80) {
          queue.add(List.from(current)..add(neighbor));
        }
      }
    }

    if (allPaths.isEmpty) return null;

    allPaths.sort((a, b) {
      if (preferFewerTransfers) {
        int tA = countTransfers(a), tB = countTransfers(b);
        return tA != tB ? tA.compareTo(tB) : a.length.compareTo(b.length);
      }
      return a.length != b.length ? a.length.compareTo(b.length) : countTransfers(a).compareTo(countTransfers(b));
    });

    final chosenPath = allPaths.first.map((name) => getStationByName(name)!).toList();
    final transfers = countTransfers(allPaths.first);

    int metroMoves = 0, monorailMoves = 0, brtMoves = 0;
    for (int i = 0; i < chosenPath.length - 1; i++) {
      final cur = chosenPath[i];
      final nxt = chosenPath[i + 1];
      if (cur.lines.contains("BRT Ring Road") && nxt.lines.contains("BRT Ring Road")) {
        brtMoves++;
      } else if (cur.lines.contains("Monorail East") && nxt.lines.contains("Monorail East")) {
        monorailMoves++;
      } else {
        metroMoves++;
      }
    }

    int transferTime = transfers * 7;
    int totalTime = (metroMoves * 3) + (monorailMoves * 4) + (brtMoves * 4) + transferTime;

    return TripResult(
      path: chosenPath,
      stationCount: chosenPath.length,
      estimatedTimeMinutes: totalTime,
      ticketPrice: FareCalculatorService.calculateTotalFare(chosenPath, passengerType),
      instructions: RouteInstructionsService.build(chosenPath),
      transferCount: transfers,
    );
  }
}