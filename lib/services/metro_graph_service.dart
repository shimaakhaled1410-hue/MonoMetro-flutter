import 'package:metro/data/lines_data.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/routing_preference.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/trip_result.dart';
import 'package:metro/models/trip_segment.dart';
import 'package:metro/services/fare_calculator_service.dart';
import 'package:metro/services/station_repository.dart';

class _RideEdge {
  const _RideEdge(this.to, this.line, this.minutes);

  final String to;
  final TransitLine line;
  final int minutes;
}

class _WalkEdge {
  const _WalkEdge(this.to, this.minutes);

  final String to;
  final int minutes;
}

enum _StepType { ride, switchLine, walk }

class _State {
  const _State(this.station, this.line);

  final String station;
  final TransitLine line;

  String get key => '$station#${line.index}';
}

class _Step {
  const _Step(this.fromKey, this.type, {this.walkMinutes = 0});

  final String fromKey;
  final _StepType type;
  final int walkMinutes;
}

class _Hop {
  const _Hop(this.step, this.from, this.to);

  final _Step step;
  final _State from;
  final _State to;
}

class MetroGraphService {
  MetroGraphService() {
    _build();
  }

  static const int _comfortTransferPenalty = 12;
  static const int _costScale = 10;

  final Map<String, List<_RideEdge>> _rideEdges = {};
  final Map<String, List<_WalkEdge>> _walkEdges = {};
  final Map<TransitLine, Map<String, Set<String>>> _lineNeighbors = {};
  final Set<TransitLine> _loopLines = {};

  void _build() {
    for (final segment in LinesData.segments) {
      final names = segment.stations;
      for (var i = 0; i < names.length - 1; i++) {
        _connect(segment.line, names[i], names[i + 1]);
      }
      if (segment.isLoop && names.length > 2) {
        _connect(segment.line, names.last, names.first);
        _loopLines.add(segment.line);
      }
    }
    for (final link in LinesData.walkLinks) {
      _walkEdges
          .putIfAbsent(link.from, () => [])
          .add(_WalkEdge(link.to, link.minutes));
      _walkEdges
          .putIfAbsent(link.to, () => [])
          .add(_WalkEdge(link.from, link.minutes));
    }
  }

  void _connect(TransitLine line, String a, String b) {
    _addRide(line, a, b);
    _addRide(line, b, a);
  }

  void _addRide(TransitLine line, String from, String to) {
    final edges = _rideEdges.putIfAbsent(from, () => []);
    if (edges.any((edge) => edge.to == to && edge.line == line)) return;
    edges.add(_RideEdge(to, line, line.mode.minutesPerStop));
    _lineNeighbors
        .putIfAbsent(line, () => {})
        .putIfAbsent(from, () => <String>{})
        .add(to);
  }

  bool isWalkLinked(String a, String b) {
    return (_walkEdges[a] ?? const <_WalkEdge>[]).any((edge) => edge.to == b);
  }

  int walkMinutesBetween(String a, String b) {
    for (final edge in _walkEdges[a] ?? const <_WalkEdge>[]) {
      if (edge.to == b) return edge.minutes;
    }
    return 0;
  }

  /// Rebuilds the segments of a previously saved trip from its ordered station
  /// names, so saved trips can be shown with lines, transfers and walks.
  /// Returns null if the stored path no longer matches the network.
  TripResult? rebuildTrip(
    List<String> stationNames,
    PassengerType passengerType,
  ) {
    if (stationNames.length < 2) return null;
    if (stationNames.any((name) => StationRepository.byName(name) == null)) {
      return null;
    }

    final hops = <_Hop>[];
    TransitLine? current;

    for (var i = 0; i < stationNames.length - 1; i++) {
      final from = stationNames[i];
      final to = stationNames[i + 1];
      final lines = _linesBetween(from, to);

      if (lines.isEmpty) {
        if (!isWalkLinked(from, to)) return null;
        final fromLine = StationRepository.byName(from)!.primaryLine;
        final toLine = StationRepository.byName(to)!.primaryLine;
        hops.add(
          _Hop(
            _Step('', _StepType.walk, walkMinutes: walkMinutesBetween(from, to)),
            _State(from, fromLine),
            _State(to, toLine),
          ),
        );
        current = null;
        continue;
      }

      final line = current != null && lines.contains(current)
          ? current
          : _longestRun(lines, stationNames, i);
      if (current != null && current != line) {
        hops.add(
          _Hop(
            _Step('', _StepType.switchLine),
            _State(from, current),
            _State(from, line),
          ),
        );
      }
      hops.add(
        _Hop(
          _Step('', _StepType.ride),
          _State(from, line),
          _State(to, line),
        ),
      );
      current = line;
    }

    final segments = _buildSegments(hops);
    if (segments.isEmpty) return null;

    return TripResult(
      segments: segments,
      fare: FareCalculatorService.calculate(segments, passengerType),
      estimatedTimeMinutes: _estimateMinutes(segments),
    );
  }

  List<TransitLine> _linesBetween(String a, String b) {
    return [
      for (final edge in _rideEdges[a] ?? const <_RideEdge>[])
        if (edge.to == b) edge.line,
    ];
  }

  TransitLine _longestRun(
    List<TransitLine> candidates,
    List<String> names,
    int index,
  ) {
    var best = candidates.first;
    var bestRun = -1;
    for (final line in candidates) {
      var run = 0;
      for (var j = index; j < names.length - 1; j++) {
        if (!_linesBetween(names[j], names[j + 1]).contains(line)) break;
        run++;
      }
      if (run > bestRun) {
        best = line;
        bestRun = run;
      }
    }
    return best;
  }

  TripResult? calculateTrip(
    String start,
    String end,
    PassengerType passengerType, {
    RoutingPreference preference = RoutingPreference.fastest,
  }) {
    final startStation = StationRepository.byName(start);
    final endStation = StationRepository.byName(end);
    if (startStation == null || endStation == null || start == end) {
      return null;
    }

    final transferCost =
        LinesData.transferMinutes +
        (preference == RoutingPreference.comfortable
            ? _comfortTransferPenalty
            : 0);

    final distances = <String, int>{};
    final states = <String, _State>{};
    final previous = <String, _Step>{};
    final visited = <String>{};
    final frontier = <String>{};

    void push(_State state, int cost, _Step? step) {
      final key = state.key;
      final known = distances[key];
      if (known != null && known <= cost) return;
      distances[key] = cost;
      states[key] = state;
      if (step == null) {
        previous.remove(key);
      } else {
        previous[key] = step;
      }
      frontier.add(key);
    }

    for (final line in startStation.lines) {
      push(_State(start, line), 0, null);
    }

    String? goalKey;
    while (frontier.isNotEmpty) {
      var currentKey = frontier.first;
      for (final key in frontier) {
        if (distances[key]! < distances[currentKey]!) currentKey = key;
      }
      frontier.remove(currentKey);
      if (!visited.add(currentKey)) continue;

      final current = states[currentKey]!;
      final currentCost = distances[currentKey]!;
      if (current.station == end) {
        goalKey = currentKey;
        break;
      }

      for (final edge in _rideEdges[current.station] ?? const <_RideEdge>[]) {
        if (edge.line != current.line) continue;
        push(
          _State(edge.to, edge.line),
          currentCost + edge.minutes * _costScale + 1,
          _Step(currentKey, _StepType.ride),
        );
      }

      final station = StationRepository.byName(current.station)!;
      for (final line in station.lines) {
        if (line == current.line) continue;
        push(
          _State(current.station, line),
          currentCost + transferCost * _costScale + 1,
          _Step(currentKey, _StepType.switchLine),
        );
      }

      for (final walk in _walkEdges[current.station] ?? const <_WalkEdge>[]) {
        final target = StationRepository.byName(walk.to);
        if (target == null) continue;
        for (final line in target.lines) {
          push(
            _State(walk.to, line),
            currentCost + walk.minutes * _costScale + 1,
            _Step(currentKey, _StepType.walk, walkMinutes: walk.minutes),
          );
        }
      }
    }

    if (goalKey == null) return null;

    final hops = <_Hop>[];
    var key = goalKey;
    while (true) {
      final step = previous[key];
      if (step == null) break;
      hops.add(_Hop(step, states[step.fromKey]!, states[key]!));
      key = step.fromKey;
    }
    final ordered = hops.reversed.toList();

    final segments = _buildSegments(ordered);
    if (segments.isEmpty) return null;

    return TripResult(
      segments: segments,
      fare: FareCalculatorService.calculate(segments, passengerType),
      estimatedTimeMinutes: _estimateMinutes(segments),
    );
  }

  List<TripSegment> _buildSegments(List<_Hop> hops) {
    final segments = <TripSegment>[];
    var rideStations = <Station>[];
    TransitLine? rideLine;

    void closeRide() {
      final line = rideLine;
      if (line != null && rideStations.length > 1) {
        segments.add(
          TripSegment(
            type: SegmentType.ride,
            stations: rideStations,
            line: line,
            towards: _resolveTowards(line, rideStations),
          ),
        );
      }
      rideStations = <Station>[];
      rideLine = null;
    }

    for (final hop in hops) {
      switch (hop.step.type) {
        case _StepType.ride:
          if (rideStations.isEmpty) {
            rideStations.add(StationRepository.byName(hop.from.station)!);
          }
          rideLine = hop.to.line;
          rideStations.add(StationRepository.byName(hop.to.station)!);
        case _StepType.switchLine:
          closeRide();
        case _StepType.walk:
          closeRide();
          segments.add(
            TripSegment(
              type: SegmentType.walk,
              stations: [
                StationRepository.byName(hop.from.station)!,
                StationRepository.byName(hop.to.station)!,
              ],
              walkMinutes: hop.step.walkMinutes,
            ),
          );
      }
    }
    closeRide();
    return segments;
  }

  Station? _resolveTowards(TransitLine line, List<Station> stations) {
    final last = stations.last;
    if (_loopLines.contains(line) || stations.length < 2) return last;

    final visited = <String>{stations[stations.length - 2].name, last.name};
    var current = last.name;
    while (true) {
      final neighbors = (_lineNeighbors[line]?[current] ?? const <String>{})
          .where((name) => !visited.contains(name))
          .toList();
      if (neighbors.length != 1) break;
      current = neighbors.first;
      visited.add(current);
    }
    return StationRepository.byName(current);
  }

  int _estimateMinutes(List<TripSegment> segments) {
    var total = 0;
    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (segment.isWalk) {
        total += segment.walkMinutes;
        continue;
      }
      total += segment.stops * segment.line!.mode.minutesPerStop;
      if (i > 0 && !segments[i - 1].isWalk) total += LinesData.transferMinutes;
    }
    return total;
  }
}
