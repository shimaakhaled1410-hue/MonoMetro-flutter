import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class _NavDestination {
  const _NavDestination({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
  });

  final String labelKey;
  final IconData icon;
  final IconData activeIcon;
}

/// Floating pill navigation bar. Only the selected destination shows its
/// label, which keeps the bar light and lets the content breathe.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavDestination> _destinations = [
    _NavDestination(
      labelKey: 'nav_home',
      icon: Icons.directions_subway_outlined,
      activeIcon: Icons.directions_subway_rounded,
    ),
    _NavDestination(
      labelKey: 'nav_brt',
      icon: Icons.directions_bus_outlined,
      activeIcon: Icons.directions_bus_rounded,
    ),
    _NavDestination(
      labelKey: 'nav_history',
      icon: Icons.history_rounded,
      activeIcon: Icons.manage_history_rounded,
    ),
    _NavDestination(
      labelKey: 'nav_settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(32);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: palette.shadow.withValues(
                alpha: context.isDark ? 0.45 : 0.10,
              ),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: palette.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _destinations.length; i++)
                  _NavItem(
                    destination: _destinations[i],
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = destination.labelKey.tr;
    final foreground = isSelected ? palette.onCta : palette.muted;
    const shape = StadiumBorder();

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: AlignmentDirectional.centerStart,
        child: Material(
          color: isSelected ? palette.cta : Colors.transparent,
          shape: shape,
          child: InkWell(
            customBorder: shape,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? destination.activeIcon : destination.icon,
                    size: 24,
                    color: foreground,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: foreground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
