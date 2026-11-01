import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/views/brt_view.dart';
import 'history_view.dart';
import 'home_view.dart';
import 'settings_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    const BrtView(),
    const HistoryView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E222B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF2C3240) : Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    label: 'nav_home'.tr,
                    icon: Icons.directions_subway_outlined,
                    activeIcon: Icons.directions_subway_rounded,
                    primaryColor: primaryColor,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    label: 'nav_brt'.tr,
                    icon: Icons.directions_bus_outlined,
                    activeIcon: Icons.directions_bus_rounded,
                    primaryColor: const Color(0xFFF39C12),
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    label: 'nav_history'.tr,
                    icon: Icons.history_rounded,
                    activeIcon: Icons.manage_history_rounded,
                    primaryColor: primaryColor,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    label: 'nav_settings'.tr,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings_rounded,
                    primaryColor: primaryColor,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required Color primaryColor,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: isDark ? 0.25 : 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected
                  ? primaryColor
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? primaryColor
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
