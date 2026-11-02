import 'package:flutter/material.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/models/transit_mode.dart';

enum TransitLine {
  line1(
    mode: TransitMode.metro,
    labelKey: 'line_1',
    color: AppColors.line1,
  ),
  line2(
    mode: TransitMode.metro,
    labelKey: 'line_2',
    color: AppColors.line2,
  ),
  line3(
    mode: TransitMode.metro,
    labelKey: 'line_3',
    color: AppColors.line3,
  ),
  monorailEast(
    mode: TransitMode.monorail,
    labelKey: 'monorail_line',
    color: AppColors.monorail,
  ),
  brtRing(
    mode: TransitMode.brt,
    labelKey: 'brt_line',
    color: AppColors.brt,
  );

  const TransitLine({
    required this.mode,
    required this.labelKey,
    required this.color,
  });

  final TransitMode mode;
  final String labelKey;
  final Color color;
}
