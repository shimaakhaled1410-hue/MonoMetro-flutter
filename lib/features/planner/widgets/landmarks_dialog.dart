import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/data/landmarks_data.dart';
import 'package:metro/models/landmark.dart';
import 'package:metro/models/station.dart';
import 'package:metro/services/station_repository.dart';

class LandmarksDialog extends StatelessWidget {
  const LandmarksDialog({super.key, required this.onSelect});

  final void Function(Station station, String landmarkTitle) onSelect;

  void _handleTap(BuildContext context, Landmark landmark) {
    final station = StationRepository.byName(landmark.stationName);
    Navigator.pop(context);
    if (station != null) onSelect(station, landmark.localizedTitle);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.brand;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 520),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 14, 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.explore_rounded, color: primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'landmarks_title'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.onSurfaceStrong,
                          ),
                        ),
                        Text(
                          'landmarks_subtitle'.tr,
                          style: TextStyle(fontSize: 12, color: context.mutedColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 64,
                  ),
                  itemCount: LandmarksData.all.length,
                  itemBuilder: (context, index) {
                    final landmark = LandmarksData.all[index];
                    return InkWell(
                      onTap: () => _handleTap(context, landmark),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF262C3A)
                              : const Color(0xFFF6F8FC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.grey.shade200,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            landmark.localizedTitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: context.onSurfaceStrong,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
