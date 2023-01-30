import '/models/member.dart';

class Team {
  final String teamID;
  final bool visible;
  final List<Member> admins;
  final String name;
  final List<Member> members;
  final String description;
  

  Team({
    this.teamID, 
    this.visible, 
    this.admins,
    this.name, 
    this.members, 
    this.description});

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    // var parsedJson = jsonDecode(parseString);
    String adminID = parsedJson["admin"]["_id"];
    List<Member> adminList = [];
    List<Member> memberList = [];
    List<dynamic> memberStrings = List.from(parsedJson["members"]);
    for(int i = 0; i < memberStrings.length; i++){
      Member newMem = Member.fromJson(memberStrings[i], adminID);
      if(newMem.isAdmin) adminList.add(newMem);
      memberList.add(newMem);
    }
    return Team(
        teamID:  parsedJson["_id"],
        visible: parsedJson["visible"],
        admins: adminList,
        name: parsedJson["name"],
        members: memberList,
        description: parsedJson["description"]
    );
  }

  factory Team.fromJsonSearch(Map<String, dynamic> parsedJson) {
    // var parsedJson = jsonDecode(parseString);
    String adminID = parsedJson["admin"];
    List<Member> adminList = [];
    List<Member> memberList = [];
    return Team(
        teamID:  parsedJson["_id"],
        visible: parsedJson["visible"],
        admins: adminList,
        name: parsedJson["name"],
        members: memberList,
        description: parsedJson["description"]
    );
  }
}
