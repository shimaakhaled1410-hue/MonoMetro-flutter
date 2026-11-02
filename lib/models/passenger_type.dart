enum PassengerType {
  normal(labelKey: 'normal_passenger'),
  senior(labelKey: 'senior_passenger'),
  specialNeeds(labelKey: 'special_needs');

  const PassengerType({required this.labelKey});

  final String labelKey;

  static PassengerType fromName(String? name) {
    for (final type in PassengerType.values) {
      if (type.name == name) return type;
    }
    return PassengerType.normal;
  }
}
