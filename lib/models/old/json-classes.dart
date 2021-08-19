import 'package:json_annotation/json_annotation.dart';
part 'json-classes.g.dart';

@JsonSerializable()
class CheckinItem{
  @JsonKey(defaultValue: false)
  bool has_checked_in; // ignore: non_constant_identifier_names
  @JsonKey(defaultValue: "")
  String check_in_timestamp; // ignore: non_constant_identifier_names
  int checkin_limit; // ignore: non_constant_identifier_names
  bool self_checkin_enabled; // ignore: non_constant_identifier_names
  int points;
  @JsonKey(name: '_id')
  String id;
  String name;
  String desc;
  String date;
  int lat;
  int long;
  int units;
  int access_code; // ignore: non_constant_identifier_names
  int active_status; // ignore: non_constant_identifier_names

  CheckinItem(this.has_checked_in, this.check_in_timestamp, this.checkin_limit,
      this.self_checkin_enabled, this.points,
      this.id, this.name, this.desc, this.date, this.lat, this.long,
      this.units, this.access_code, this.active_status);


  factory CheckinItem.fromJson(Map<String, dynamic> json) =>
      _$CheckinItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinItemToJson(this);
}

@JsonSerializable()
class CheckinEvent{
  @JsonKey(name: '_id')
  String id;
  String timestamp;
  CheckinItem checkin_item; // ignore: non_constant_identifier_names
  String user;

  CheckinEvent(this.id, this.timestamp, this.checkin_item, this.user);

  factory CheckinEvent.fromJson(Map<String, dynamic> json) =>
      _$CheckinEventFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinEventToJson(this);

}

@JsonSerializable()
class Participant{
  int total_points; // ignore: non_constant_identifier_names
  @JsonKey(name: '_id')
  String id;
  String name;
  String email;

  Participant(this.total_points, this.id, this.name, this.email);

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
