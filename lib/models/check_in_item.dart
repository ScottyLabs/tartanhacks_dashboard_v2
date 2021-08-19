class CheckInItem {
  final int points;
  final String accessLevel;
  final bool active;
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
      id: parsedJson['_id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      event: parsedJson['event']
    );
  }
}