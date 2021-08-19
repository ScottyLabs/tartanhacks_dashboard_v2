// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json-classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinItem _$CheckinItemFromJson(Map<String, dynamic> json) {
  return CheckinItem(
    json['has_checked_in'] as bool ?? false,
    json['check_in_timestamp'] as String ?? '',
    json['checkin_limit'] as int,
    json['self_checkin_enabled'] as bool,
    json['points'] as int,
    json['_id'] as String,
    json['name'] as String,
    json['desc'] as String,
    json['date'] as String,
    json['lat'] as int,
    json['long'] as int,
    json['units'] as int,
    json['access_code'] as int,
    json['active_status'] as int,
  );
}

Map<String, dynamic> _$CheckinItemToJson(CheckinItem instance) =>
    <String, dynamic>{
      'has_checked_in': instance.has_checked_in,
      'check_in_timestamp': instance.check_in_timestamp,
      'checkin_limit': instance.checkin_limit,
      'self_checkin_enabled': instance.self_checkin_enabled,
      'points': instance.points,
      '_id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'date': instance.date,
      'lat': instance.lat,
      'long': instance.long,
      'units': instance.units,
      'access_code': instance.access_code,
      'active_status': instance.active_status,
    };

CheckinEvent _$CheckinEventFromJson(Map<String, dynamic> json) {
  return CheckinEvent(
    json['_id'] as String,
    json['timestamp'] as String,
    json['checkin_item'] == null
        ? null
        : CheckinItem.fromJson(json['checkin_item'] as Map<String, dynamic>),
    json['user'] as String,
  );
}

Map<String, dynamic> _$CheckinEventToJson(CheckinEvent instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'timestamp': instance.timestamp,
      'checkin_item': instance.checkin_item,
      'user': instance.user,
    };

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
    json['total_points'] as int,
    json['_id'] as String,
    json['name'] as String,
    json['email'] as String,
  );
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'total_points': instance.total_points,
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
