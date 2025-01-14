class Project{
  final String id;
  final String name;
  final String desc;
  final String event; //objectid
  final String url;
  final String slides;
  final String video;
  final String team; //objectid
  final List prizes; //objectid
  final bool presentingVirtually;
  final int? tableNumber;

  Project({
    required this.id,
    required this.name,
    required this.desc,
    required this.event,
    required this.url,
    required this.slides,
    required this.video,
    required this.team,
    required this.prizes,
    required this.presentingVirtually,
    this.tableNumber,
  });

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    Project project = Project(
      id: parsedJson['_id'],
      name: parsedJson['name'],
      desc: parsedJson['description'],
      event: parsedJson['event'],
      url: parsedJson['url'],
      slides: parsedJson['slides'],
      video: parsedJson['video'],
      team: parsedJson['team'],
      prizes: parsedJson['prizes'],
      presentingVirtually: parsedJson['presentingVirtually'],
      tableNumber: parsedJson['tableNumber'],
    );
    return project;
  }
}