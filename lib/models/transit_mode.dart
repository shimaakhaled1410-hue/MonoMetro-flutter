enum TransitMode {
  metro(labelKey: 'metro', shortLabelKey: 'metro_short', minutesPerStop: 3),
  monorail(
    labelKey: 'monorail',
    shortLabelKey: 'monorail_short',
    minutesPerStop: 4,
  ),
  brt(labelKey: 'brt', shortLabelKey: 'brt_short', minutesPerStop: 4);

  const TransitMode({
    required this.labelKey,
    required this.shortLabelKey,
    required this.minutesPerStop,
  });

  final String labelKey;
  final String shortLabelKey;
  final int minutesPerStop;

  static TransitMode? fromName(String? name) {
    for (final mode in TransitMode.values) {
      if (mode.name == name) return mode;
    }
    return null;
  }
}
