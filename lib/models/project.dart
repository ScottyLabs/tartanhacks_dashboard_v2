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

  Project(
      {this.id,
      this.name,
      this.desc,
      this.event,
      this.url,
      this.slides,
      this.video,
      this.team,
      this.prizes,
      this.presentingVirtually});

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
      presentingVirtually: parsedJson['presentingVirtually']
    );
    return project;
  }
}