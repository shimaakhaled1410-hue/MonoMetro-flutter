import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/format_date.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/features/history/views/trip_details_view.dart';
import 'package:metro/features/history/widgets/trip_history_card.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  Future<void> _confirmClear(
    BuildContext context,
    HistoryController controller,
  ) async {
    if (controller.historyList.isEmpty) return;

    final dangerColor = context.palette.danger;

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
              style: TextStyle(color: dangerColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) controller.clearAllWithUndo();
  }

  List<Widget> _buildItems(HistoryController controller) {
    final widgets = <Widget>[];
    String? lastDay;

    for (final item in controller.historyList) {
      final day = dayLabel(item.timestamp);
      if (day != lastDay) {
        widgets.add(_DayHeader(label: day));
        lastDay = day;
      }
      widgets.add(
        TripHistoryCard(
          key: ValueKey(item.id),
          item: item,
          onTap: () => Get.to(() => TripDetailsView(item: item)),
          onDelete: () => controller.deleteItemWithUndo(item),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('trip_history'.tr),
        actions: [
          IconButton(
            tooltip: 'clear_history'.tr,
            style: IconButton.styleFrom(
              backgroundColor: context.fieldColor,
              foregroundColor: context.onSurfaceStrong,
            ),
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () => _confirmClear(context, controller),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyList.isEmpty) {
          return const _EmptyState();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: _buildItems(controller),
        );
      }),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, top: 12, bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: context.mutedColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: context.fieldColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 44,
              color: context.mutedColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'no_trips'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.mutedColor,
            ),
          ),
        ],
      ),
    );
  }
}
