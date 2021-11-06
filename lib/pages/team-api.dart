import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'custom_widgets.dart';
import '/models/team.dart';
//right now

Future<bool> createTeam(String team_name, 
                         String team_description, 
                         bool team_visible, 
                         String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'name' : team_name, 
  'description': team_description, 'visible': team_visible});
  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
      print("Successfully created teamSuccess");
    return true;
  }
  return null;
}

Future<<List>> getTeamInfo(String teamId, 
                         String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/" + teamId;

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  //var body = json.encode({'name' : team_name, 
  //'description': team_description, 'visible': team_visible});
  final response = await http.post(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Team team = new Team.fromJson(data);
    print("Successfully created get team");
    return team;
  }
  return null;
}

Future<List<Team>> getTeams(String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/teams";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    List<String> teamStrings = List.from(jsonDecode(response.body));
    List<Team> teamsList = [];
    for(int i = 0; i < teamStrings.length; i++){
      teamsList[i] = Team.fromJson(teamStrings[i]);
    }
    print("Successfully retrieved all team Success");
    return teamsList;
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
  return null;
}

Future<void> inviteTeamMember(String user_email, String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/invite";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'email': user_email});
  //can we check if a user is already on a team by email???
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
  const url = "https://tartanhacks-backend.herokuapp.com/team/join/" + team_id;
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request");
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

/*

Future<bool> inviteTeamMember(String team_id, String user_id, bool token, BuildContext context) async {
  var url = "https://tartanhacks-backend.herokuapp.com/teams/invite/" + user_id;

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  var body = json.encode({'team_id' : team_id, 'user_id' : user_id});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
      errorDialog(context, "Successfully invited member", "Success");
    return true;
  }
  return null;
}

Future<bool> joinTeam(String team_id, String token, BuildContext context) async {
  var url = "https://tartanhacks-backend.herokuapp.com/teams/invite/" + team_id;

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  var body = json.encode({'team_id' : team_id});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    errorDialog(context, "Successfully joined team", "Success");
    return true;
  }
  errorDialog(context, json.decode(response.body)['message'].toString(), "Unsuccessful");
  return null;
}

*/
/*
list of modules to interact with 
- request team
- request user
- request accept
- request decline
- request cancel
- invite a team member
    - need something to say you've reached member limit
- leave a team
- create a team

NEEDED:
- fields: team ids, team descriptions, tokens???
- moduels: get list of team members, edit team description

QUESTIONS/TO DO:
- how do you actually connect to the api
- brainstorm more fields and modules that we need
- how to connect buttons to the output
- how to display error messages
*/