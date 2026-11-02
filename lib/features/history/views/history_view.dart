import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/features/history/widgets/trip_history_card.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  Future<void> _confirmClear(HistoryController controller) async {
    if (controller.historyList.isEmpty) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('clear_history'.tr),
        content: Text('clear_history_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) controller.clearAllWithUndo();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('trip_history'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'clear_history'.tr,
            onPressed: () => _confirmClear(controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyList.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 56, color: context.mutedColor),
                const SizedBox(height: 12),
                Text(
                  'no_trips'.tr,
                  style: TextStyle(fontSize: 16, color: context.mutedColor),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.historyList.length,
          itemBuilder: (_, index) {
            final item = controller.historyList[index];
            return TripHistoryCard(
              key: ValueKey(item.id),
              item: item,
              onDelete: () => controller.deleteItemWithUndo(item),
            );
          },
        );
      }),
    );
  }
}
