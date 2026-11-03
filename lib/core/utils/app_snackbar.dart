import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/theme/app_palette.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 4),
    TextButton? mainButton,
  }) {
    Get.closeCurrentSnackbar();

    final isDark = Get.isDarkMode;
    final palette = AppPalette.of(isDark);

    late final Color accentColor;
    late final IconData iconData;

    switch (type) {
      case SnackbarType.success:
        accentColor = palette.success;
        iconData = Icons.check_circle_rounded;
        break;
      case SnackbarType.error:
        accentColor = palette.danger;
        iconData = Icons.error_rounded;
        break;
      case SnackbarType.warning:
        accentColor = palette.warning;
        iconData = Icons.warning_rounded;
        break;
      case SnackbarType.info:
        accentColor = palette.info;
        iconData = Icons.info_rounded;
        break;
    }

    final backgroundColor = palette.surface;
    final primaryTextColor = palette.text;
    final secondaryTextColor = palette.text.withValues(alpha: 0.70);
    final borderColor = palette.border;

    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      borderRadius: 16,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.zero,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 350),
      borderWidth: 1,
      borderColor: borderColor,
      boxShadows: [
        BoxShadow(
          color: palette.shadow.withValues(alpha: isDark ? 0.40 : 0.10),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      titleText: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 12, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(iconData, color: accentColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                letterSpacing: 0.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (mainButton != null) ...[
                        const SizedBox(width: 8),
                        mainButton,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      messageText: const SizedBox.shrink(),
    );
  }

  static void showWithUndo({
    required String title,
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 4),
  }) {
    final warningColor = AppPalette.of(Get.isDarkMode).warning;

    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      mainButton: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: warningColor,
          backgroundColor: warningColor.withValues(alpha: 0.12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Get.closeCurrentSnackbar();
          onUndo();
        },
        child: Text(
          'undo'.tr,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  static void success({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.success);
  }

  static void error({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.error);
  }

  static void warning({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.warning);
  }

  static void info({required String title, required String message}) {
    show(title: title, message: message, type: SnackbarType.info);
  }
}
