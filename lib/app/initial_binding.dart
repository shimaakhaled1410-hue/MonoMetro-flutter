import 'package:get/get.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';
import 'package:metro/services/metro_graph_service.dart';
import 'package:metro/services/settings_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final settings = Get.find<SettingsService>();
    Get.put(SettingsController(settings), permanent: true);
    final history = Get.put(HistoryController(), permanent: true);
    Get.put(
      MetroController(
        graphService: MetroGraphService(),
        settings: settings,
        history: history,
      ),
      permanent: true,
    );
  }
}
