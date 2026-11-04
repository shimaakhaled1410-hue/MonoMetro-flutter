import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/core/widgets/app_sheet.dart';
import 'package:metro/data/landmarks_data.dart';
import 'package:metro/models/landmark.dart';
import 'package:metro/models/station.dart';
import 'package:metro/services/station_repository.dart';

class LandmarksSheet extends StatelessWidget {
  const LandmarksSheet({super.key, required this.onSelect});

  final void Function(Station station, String landmarkTitle) onSelect;

  static Future<void> show(
    BuildContext context, {
    required void Function(Station station, String landmarkTitle) onSelect,
  }) {
    return AppSheet.show<void>(
      context,
      builder: (_) => LandmarksSheet(onSelect: onSelect),
    );
  }

  void _handleTap(BuildContext context, Landmark landmark) {
    final station = StationRepository.byName(landmark.stationName);
    Navigator.pop(context);
    if (station != null) onSelect(station, landmark.localizedTitle);
  }

  @override
  Widget build(BuildContext context) {
    final landmarks = LandmarksData.all;

    return AppSheet(
      icon: Icons.explore_rounded,
      title: 'landmarks_title'.tr,
      subtitle: 'landmarks_subtitle'.tr,
      heightFactor: 0.78,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        itemCount: landmarks.length,
        separatorBuilder: (_, _) =>
            Divider(height: 1, indent: 64, endIndent: 8),
        itemBuilder: (_, index) => _LandmarkTile(
          landmark: landmarks[index],
          onTap: () => _handleTap(context, landmarks[index]),
        ),
      ),
    );
  }
}

class _LandmarkTile extends StatelessWidget {
  const _LandmarkTile({required this.landmark, required this.onTap});

  final Landmark landmark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stationName =
        StationRepository.byName(landmark.stationName)?.localizedName;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.fieldColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.place_rounded,
                size: 22,
                color: context.palette.endMarker,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    landmark.localizedTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.onSurfaceStrong,
                    ),
                  ),
                  if (stationName != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_subway_rounded,
                          size: 13,
                          color: context.mutedColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            stationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.mutedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: context.mutedColor,
            ),
          ],
        ),
      ),
    );
  }
}
