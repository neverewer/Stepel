/// {@template profile_data_update_event}
/// ProfileDataUpdateEvent class
/// {@endtemplate}
class ProfileDataUpdateEvent {
  /// {@macro profile_data_update_event}
  const ProfileDataUpdateEvent(this.value, this.updatedField);

  final num value;

  final ProfileDataField updatedField;
}

enum ProfileDataField {
  stepTarget,
  cardioPointsTarget,
  weigth,
  heigth,
}
