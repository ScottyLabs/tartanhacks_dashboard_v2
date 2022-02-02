import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'custom_widgets.dart';
import '/models/team.dart';
import '/models/member.dart';
import 'dart:developer';

const baseUrl = "https://backend.tartanhacks.com/";

Future<bool> createTeam(
    String teamName, String description, bool visibility, String token) async {
  String url = baseUrl + "team/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  print("try to create");
  String body = '{"name": "' +
      teamName +
      '","description": "' +
      description +
      '","visible": ' +
      visibility.toString() +
      '}';
  print(body);
  final response = await http.post(url, headers: headers, body: body); //patch?
  if (response.statusCode == 200) {
    print("Successfully updated info");
  } else {
    print("error");
  }
  print("response text");
  var decoded = utf8.decode(response.bodyBytes);
  print(decoded);
}

Future<bool> editTeam(
    String teamName, String description, bool visibility, String token) async {
  String url = baseUrl + "team/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  print("try to create");
  String body = '{"name": "' +
      teamName +
      '","description": "' +
      description +
      '","visible": ' +
      visibility.toString() +
      '}';
  print(body);
  final response = await http.patch(url, headers: headers, body: body); //patch?
  if (response.statusCode == 200) {
    print("Successfully updated info");
  } else {
    print("error");
  }
  print("response text");
  var decoded = utf8.decode(response.bodyBytes);
  print(decoded);
}

Future<bool> promoteToAdmin(String userID, String token) async {
  String url =
      baseUrl + "team/promote/" + userID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers);
  print(response);
  if (response.statusCode == 200) {
    print("Successfully promoted member");
    return true;
  } else {
    print("did not work");
    return false;
  }
}

Future<Team> getUserTeam(String token) async {
  String url = baseUrl + "user/team";

  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var parsedJson = jsonDecode(response.body);
    if (response.body.contains("You are not in a team!")) {
      return null;
    }
    Team team = new Team.fromJson(parsedJson);
    return team;
  }
  return null;
}

Future<List<dynamic>> getTeamMail(String token) async {
  String url = baseUrl + "requests/team";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print(data);
    return data;
  }
}

Future<void> acceptRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/accept/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers);
  if (response.statusCode == 200) {
    print("success");
  }
}

Future<void> cancelRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/cancel/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers);
  if (response.statusCode == 200) {
    print("success");
  }
}

Future<void> declineRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/cancel/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers);
  if (response.statusCode == 200) {
    print("success");
  }
}

Future<List<dynamic>> getUserMail(String token) async {
  String url = baseUrl + "requests/user";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print("received requests for current team");
    print(data);
    return data;
  }
}

Future<void> inviteTeamMember(String user_email, String token) async {
  const url = baseUrl + "team/invite";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json.encode({'email': user_email});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully invited");
  } else {
    print("not successful");
  }
}

Future<void> leaveTeam(String token) async {
  const url = baseUrl + "team/leave";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully left");
    return;
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

Future<bool> requestTeam(String teamID, String token) async {
  String url = baseUrl + "team/join/" + teamID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json.encode({});
  print("Team request attempt");
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request");
    return true;
  }
  print("Error");
  return false;
}

Future<bool> requestTeamMember(String email, String token) async {
  String url = baseUrl + "team/invite";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request member");
    return true;
  }
  print("did not work");
  print(response);
  return false;
}

Future<void> updateTeamInfo(
    String name, String description, bool visible, String token) async {
  String url = baseUrl + "team/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json
      .encode({"name": name, "description": description, "visible": visible});
  final response = await http.patch(url, headers: headers, body: body); //patch?
  if (response.statusCode == 200) {
    print("Successfully updated info");
  }
  print("error");
}

Future<Team> getTeamInfo(String teamId, String token) async {
  String url = baseUrl + "team/" + teamId;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    Team team = new Team.fromJson(data);
    return team;
  }
  return null;
}

Future<List<Team>> getTeams(String token) async {
  String url = baseUrl + "teams";

  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    print("Response body: ");
    print(response.body);
    List<dynamic> teamStrings = List.from(jsonDecode(response.body));
    print("Parsed 1 success");
    List<Team> teamsList = [];
    for (int i = 0; i < teamStrings.length; i++) {
      teamsList.add(Team.fromJson(teamStrings[i]));
      print("Added team");
    }
    print("Successfully retrieved all teams");
    print(teamsList);
    return teamsList;
  }
  print(response.body);
  return null;
}
