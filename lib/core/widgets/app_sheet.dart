import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:metro/core/utils/theme_extensions.dart';

/// Shared chrome for every bottom sheet: drag handle, header with optional
/// icon and subtitle, and a close button.
///
/// Pass [heightFactor] for tall, scrollable sheets (the [child] then fills
/// the remaining space); leave it null to size the sheet to its content.
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.heightFactor,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final double? heightFactor;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final media = MediaQuery.of(context);
    final expanded = heightFactor != null;

    final body = Column(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: palette.borderStrong,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        _Header(title: title, subtitle: subtitle, icon: icon),
        if (expanded) Expanded(child: child) else child,
      ],
    );

    Widget sized = body;
    if (expanded) {
      final available =
          media.size.height - media.viewInsets.bottom - media.padding.top - 12;
      sized = SizedBox(
        height: math.min(media.size.height * heightFactor!, available),
        child: body,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Material(
        color: palette.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          side: BorderSide(color: palette.border),
        ),
        child: SafeArea(top: false, child: sized),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.subtitle, this.icon});

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 12, 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.field,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: palette.brand, size: 22),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: palette.text,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 13, color: palette.muted),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: palette.field,
              foregroundColor: palette.text,
            ),
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}
