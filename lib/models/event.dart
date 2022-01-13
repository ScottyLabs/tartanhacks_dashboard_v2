class Event {
  final String id;
  final String platform;
  final bool active;
  final String name;
  final String description;
  //time is unix
  final int startTime;
  final int endTime;
  final String location;
  final int lat;
  final int lng;
  final String platformUrl;

  Event({
    this.id,
    this.platform,
    this.active,
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.lat,
    this.lng,
    this.platformUrl
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return new Event(
      id: parsedJson['_id'],
      platform: parsedJson['platform'],
      active: true,
      name: parsedJson['name'],
      description: parsedJson['description'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      location: parsedJson['location'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      platformUrl: parsedJson['platformUrl'],
    );
  }
}

class EventDTO {
  final String platform;
  final String name;
  final String description;
  //time is unix
  final int startTime;
  final int endTime;
  final String location;
  final String platformUrl;

  EventDTO(
      {this.name,
        this.description,
        this.startTime,
        this.endTime,
        this.platform,
        this.platformUrl,
        this.location});

  EventDTO.fromEventItem(Event item):
        name = item.name,
        description = item.description,
        startTime = item.startTime,
        endTime = item.endTime,
        location = item.location,
        platform = item.platform,
        platformUrl = item.platformUrl;


  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'startTime': startTime,
    'endTime': endTime,
    'location': location,
    'platform': platform,
    'platformUrl': platformUrl
  };
}