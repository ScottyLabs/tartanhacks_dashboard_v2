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

  CheckInItem({
    required this.points,
    required this.accessLevel,
    required this.active,
    required this.enableSelfCheckIn,
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.event
  });

  factory CheckInItem.fromJson(Map<String, dynamic> parsedJson) {
    return CheckInItem(
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

  CheckInItemDTO({
    required this.points,
    required this.accessLevel,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.enableSelfCheckIn
  });

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