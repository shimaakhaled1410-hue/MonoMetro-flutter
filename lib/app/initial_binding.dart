import 'package:get/get.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/controllers/passenger_controller.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';
import 'package:metro/models/transit_network.dart';
import 'package:metro/services/metro_graph_service.dart';
import 'package:metro/services/settings_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final settings = Get.find<SettingsService>();
    Get.put(SettingsController(settings), permanent: true);
    final history = Get.put(HistoryController(), permanent: true);
    final passenger = Get.put(PassengerController(settings), permanent: true);
    final graph = Get.put(MetroGraphService(), permanent: true);

    for (final network in TransitNetwork.values) {
      Get.put(
        MetroController(
          network: network,
          graphService: graph,
          passengerController: passenger,
          historyController: history,
        ),
        tag: network.name,
        permanent: true,
      );
    }
  }
}
