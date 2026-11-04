import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/core/widgets/app_sheet.dart';
import 'package:metro/features/planner/widgets/station_tile.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/transit_network.dart';
import 'package:metro/services/station_repository.dart';
import 'package:metro/services/station_search_service.dart';

class StationPickerSheet extends StatefulWidget {
  const StationPickerSheet({
    super.key,
    required this.title,
    required this.network,
    required this.onSelected,
  });

  final String title;
  final TransitNetwork network;
  final ValueChanged<Station> onSelected;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required TransitNetwork network,
    required ValueChanged<Station> onSelected,
  }) {
    return AppSheet.show<void>(
      context,
      builder: (sheetContext) => StationPickerSheet(
        title: title,
        network: network,
        onSelected: (station) {
          Navigator.pop(sheetContext);
          onSelected(station);
        },
      ),
    );
  }

  @override
  State<StationPickerSheet> createState() => _StationPickerSheetState();
}

class _StationPickerSheetState extends State<StationPickerSheet> {
  late final List<TransitLine> _lines = widget.network.lines;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _lineIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildStationList(List<Station> stations, {bool showLines = false}) {
    if (stations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: context.mutedColor),
            const SizedBox(height: 8),
            Text(
              'no_results'.tr,
              style: TextStyle(color: context.mutedColor),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      itemCount: stations.length,
      separatorBuilder: (_, _) => Divider(height: 1, indent: 28, endIndent: 8),
      itemBuilder: (_, index) => StationTile(
        station: stations[index],
        showLines: showLines,
        onTap: () => widget.onSelected(stations[index]),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'search_station'.tr,
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildLineChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _lines.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) => _LineChip(
          line: _lines[index],
          selected: index == _lineIndex,
          onTap: () => setState(() => _lineIndex = index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchQuery.trim().isNotEmpty;

    return AppSheet(
      title: widget.title,
      heightFactor: 0.82,
      child: Column(
        children: [
          _buildSearchField(),
          if (!isSearching && _lines.length > 1) ...[
            _buildLineChips(),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: isSearching
                ? _buildStationList(
                    StationSearchService.search(_searchQuery, widget.network),
                    showLines: true,
                  )
                : _buildStationList(
                    StationRepository.forLine(_lines[_lineIndex]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LineChip extends StatelessWidget {
  const _LineChip({
    required this.line,
    required this.selected,
    required this.onTap,
  });

  final TransitLine line;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = selected ? palette.onCta : palette.text;
    const shape = StadiumBorder();

    return Material(
      color: selected ? palette.cta : palette.field,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: palette.lineColor(line),
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: palette.onCta, width: 1.5)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                line.labelKey.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
