import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/metro_data.dart';
import '../../models/station_model.dart';

class BrtStationPickerSheet extends StatefulWidget {
  final String title;
  final Function(String stationName) onSelected;

  const BrtStationPickerSheet({
    super.key,
    required this.title,
    required this.onSelected,
  });

  @override
  State<BrtStationPickerSheet> createState() => _BrtStationPickerSheetState();
}

class _BrtStationPickerSheetState extends State<BrtStationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  static const Color brtColor = Color(0xFFF39C12);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Station> _getBrtStations() {
    final brtList = MetroData.brtRingRoadNames
        .map(
          (name) =>
              MetroData.allStations.firstWhereOrNull((s) => s.name == name),
        )
        .whereType<Station>()
        .toList();

    if (_searchQuery.trim().isEmpty) return brtList;

    final query = _searchQuery.trim().toLowerCase();
    return brtList.where((s) {
      return s.name.toLowerCase().contains(query) || s.nameAr.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stations = _getBrtStations();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus_rounded,
                      color: brtColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : brtColor,
                      ),
                    ),
                  ],
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
                fillColor: isDark
                    ? const Color(0xFF1E222B)
                    : Colors.grey.shade100,
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
          const SizedBox(height: 8),
          Expanded(
            child: stations.isEmpty
                ? Center(
                    child: Text(
                      'no_trips'.tr,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: stations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final station = stations[index];
                      final isInterchange = station.lines.length > 1;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => widget.onSelected(station.name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF252A36)
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF2E3544)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: brtColor.withValues(
                                  alpha: 0.15,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: brtColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  station.localizedName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isInterchange)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.amber.shade900.withValues(
                                            alpha: 0.3,
                                          )
                                        : Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'transfer'.tr,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.amber.shade200
                                          : Colors.amber.shade900,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
