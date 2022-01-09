import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'custom_widgets.dart';
import '/models/team.dart';
import '/models/member.dart';
import 'dart:developer';

Future<bool> createTeam(String name, String description, String token) async  {
  String url = "https://tartanhacks-backend.herokuapp.com/team/";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({
  "name": name,
  "description": description,
  "visible": true
  });
  final response = await http.post(url, headers: headers, body: body); //patch?
  if (response.statusCode == 200) {
    print("Successfully updated info");
  }
  print("error");
}


Future<Team> getUserTeam(String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/user/team";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var parsedJson = jsonDecode(response.body);
    if (response.body.contains("You are not in a team!")){
      return null;
    }
    Team team = new Team.fromJson(parsedJson);
    return team;
  }
  return null;
}

Future<void> getUserMail(String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/requests/team";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print("received requests for current team");
    print(data);
  }
}

Future<void> inviteTeamMember(String user_email, String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/invite";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'email': user_email});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully invited");
  }
  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

Future<void> leaveTeam(String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/leave";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully left");
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

Future<void> requestTeam(String team_id, String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/team/join/" + team_id;
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request");
  }
  print("Error");
}

Future<bool> requestTeamMember(String email, String token) async { 
  String url = "https://tartanhacks-backend.herokuapp.com/team/invite";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'email': email});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request member");
    return true;
  }
  return false;
}

Future<void> updateTeamInfo(String name, String description, bool visible, String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/team/";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({
    "name": name,
    "description": description,
    "visible": visible
  });
  final response = await http.patch(url, headers: headers, body: body); //patch?
  if (response.statusCode == 200) {
    print("Successfully updated info");
  }
  print("error");
}

Future<Team> getTeamInfo(String teamId,
                         String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/team/" + teamId;

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    Team team = new Team.fromJson(data);
    print("Successfully created get team");
    return team;
  }
  return null;
}

Future<List<Team>> getTeams(String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/teams";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    print("Response body: ");
    print(response.body);
    List<dynamic> teamStrings = List.from(jsonDecode(response.body));
    print("Parsed 1 success");
    List<Team> teamsList = [];
    for(int i = 0; i < teamStrings.length; i++){
      teamsList.add(Team.fromJson(teamStrings[i]));
      print("Added team");
    }
    print("Successfully retrieved all teams");
    return teamsList;
  }
  return null;
}

