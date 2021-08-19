import 'prize.dart';


class Project{
  final String name;
  final String desc;
  final String slides;
  final String video;
  final String github;
  final bool willPresent;
  final List<String> prizes;
  final String id;

  Project({this.name, this.desc, this.slides, this.video, this.willPresent, this.prizes, this.github, this.id});

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    var jsonList = parsedJson['eligible_prizes'] as List;
    List<String> prizeNames = jsonList.map((i) => Prize.fromJson(i).name).toList();
    print("prize names here");
    print(prizeNames.toString());
    print("testing");
    print(parsedJson['name']);
    print(parsedJson['slides_url']);
    Project project = new Project(
        name: parsedJson['name'],
        desc: parsedJson['description'],
        slides: parsedJson['slides_url'],
        video: parsedJson['video_url'],
        willPresent: parsedJson['will_present_live'],
        prizes: prizeNames,
        github: parsedJson['github_repo_url'],
        id: parsedJson['_id']
    );
    return project;
  }
}