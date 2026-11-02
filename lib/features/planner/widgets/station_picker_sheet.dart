import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/widgets/station_tile.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/services/station_repository.dart';
import 'package:metro/services/station_search_service.dart';

class StationPickerSheet extends StatefulWidget {
  const StationPickerSheet({
    super.key,
    required this.title,
    required this.onSelected,
    this.initialLine,
  });

  final String title;
  final ValueChanged<Station> onSelected;
  final TransitLine? initialLine;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required ValueChanged<Station> onSelected,
    TransitLine? initialLine,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StationPickerSheet(
        title: title,
        initialLine: initialLine,
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

class _StationPickerSheetState extends State<StationPickerSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TransitLine.values.length,
      vsync: this,
      initialIndex: widget.initialLine?.index ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildStationList(List<Station> stations, {bool showLines = false}) {
    if (stations.isEmpty) {
      return Center(
        child: Text('no_results'.tr, style: TextStyle(color: context.mutedColor)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: stations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (_, index) => StationTile(
        station: stations[index],
        showLines: showLines,
        onTap: () => widget.onSelected(stations[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.brand;
    final isSearching = _searchQuery.trim().isNotEmpty;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333B4D) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E222B) : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'search_station'.tr,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 8),
              Expanded(
                child: _buildStationList(
                  StationSearchService.search(_searchQuery),
                  showLines: true,
                ),
              ),
            ] else ...[
              TabBar(
                controller: _tabController,
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  for (final line in TransitLine.values)
                    Tab(
                      child: Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: line.color),
                          const SizedBox(width: 6),
                          Text(line.labelKey.tr),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    for (final line in TransitLine.values)
                      _buildStationList(StationRepository.forLine(line)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
