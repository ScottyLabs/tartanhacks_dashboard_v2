import 'dart:convert';

class CheckInItem {
  final int points;
  final String accessLevel;
  final bool active;
  final bool enableSelfCheckIn;
  final String id;
  final String name;
  final String description;
  final int startTime;
  final int endTime;
  final String event; //objectid

  CheckInItem(
      {this.points,
      this.accessLevel,
      this.active,
        this.enableSelfCheckIn,
      this.id,
      this.name,
      this.description,
      this.startTime,
      this.endTime,
      this.event});

  factory CheckInItem.fromJson(Map<String, dynamic> parsedJson) {
    return new CheckInItem(
      points: parsedJson['points'],
      accessLevel: parsedJson['accessLevel'],
      active: parsedJson['active'],
      enableSelfCheckIn: parsedJson['enableSelfCheckin'],
      id: parsedJson['_id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      event: parsedJson['event']
    );
  }
}

class CheckInItemDTO {
  final String name;
  final String description;
  final int startTime;
  final int endTime;
  final int points;
  final String accessLevel;
  final bool enableSelfCheckIn;

  CheckInItemDTO(
        {this.points,
        this.accessLevel,
        this.name,
        this.description,
        this.startTime,
        this.endTime,
        this.enableSelfCheckIn});

  CheckInItemDTO.fromCheckInItem(CheckInItem item):
      name = item.name,
      description = item.description,
      startTime = item.startTime,
      endTime = item.endTime,
      points = item.points,
      accessLevel = item.accessLevel,
      enableSelfCheckIn = item.enableSelfCheckIn;


  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'startTime': startTime,
    'endTime': endTime,
    'points': points,
    'accessLevel': accessLevel,
    'enableSelfCheckin': enableSelfCheckIn
  };
}