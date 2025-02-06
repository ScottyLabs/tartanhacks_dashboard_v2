class Project {
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
  final String? tableNumber;
  final bool submitted;

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
    this.submitted = false,
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
      submitted: parsedJson['submitted'],
    );
    return project;
  }

  Project copyWith({
    String? id,
    String? name,
    String? desc,
    String? event,
    String? url,
    String? slides,
    String? video,
    String? team,
    List? prizes,
    bool? presentingVirtually,
    String? tableNumber,
    bool? submitted,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      event: event ?? this.event,
      url: url ?? this.url,
      slides: slides ?? this.slides,
      video: video ?? this.video,
      team: team ?? this.team,
      prizes: prizes ?? this.prizes,
      presentingVirtually: presentingVirtually ?? this.presentingVirtually,
      tableNumber: tableNumber ?? this.tableNumber,
      submitted: submitted ?? this.submitted,
    );
  }
}
