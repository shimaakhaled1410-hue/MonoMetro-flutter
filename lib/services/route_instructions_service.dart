import '../models/station_model.dart';

class RouteInstructionsService {
  static String getCommonLine(Station? s1, Station? s2) {
    if (s1 == null || s2 == null) return '';
    final common = s1.lines.where((l) => s2.lines.contains(l)).toList();
    return common.isNotEmpty ? common.first : '';
  }

  static List<String> build(List<Station> path) {
    if (path.length < 2) return [];
    List<String> steps = [];
    String currentLine = getCommonLine(path[0], path[1]);
    steps.add('Start at ${path[0].localizedName} ($currentLine)');

    for (int i = 1; i < path.length - 1; i++) {
      final currName = path[i].name;
      final nextName = path[i + 1].name;

      if ((currName == "Stadium" && nextName == "Stadium (Monorail)") ||
          (currName == "Stadium (Monorail)" && nextName == "Stadium")) {
        steps.add('Exit and walk ~5 mins to ${path[i + 1].localizedName}');
        currentLine = getCommonLine(path[i], path[i + 1]);
        continue;
      }

      String nextLine = getCommonLine(path[i], path[i + 1]);
      if (currentLine != nextLine && nextLine.isNotEmpty) {
        steps.add('Transfer at ${path[i].localizedName} to $nextLine');
        currentLine = nextLine;
      }
    }

    steps.add('Arrive at destination: ${path.last.localizedName}');
    return steps;
  }
}
