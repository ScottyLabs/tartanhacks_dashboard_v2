class Member {
  final String id;
  final bool isAdmin;
  final String name;
  final String email;

  Member({
    this.id,
    this.isAdmin,
    this.name,
    this.email,
  });

  factory Member.fromJson(Map<String, dynamic> parsedJson, String adminID) {
    // var parsedJson = jsonDecode(parsedString);
    bool isAdminBool = false;
    String currID = parsedJson["_id"];
    if(currID == adminID) isAdminBool = true;
    return Member(
        id:  parsedJson["_id"],
        isAdmin: isAdminBool,
        name: parsedJson["firstName"] + " " + parsedJson["lastName"],
        email: parsedJson["email"]
    );
  }
}
