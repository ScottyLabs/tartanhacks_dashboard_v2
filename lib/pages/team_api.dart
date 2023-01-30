import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '/models/team.dart';

const baseUrl = "https://dev.backend.tartanhacks.com/";

Future<http.Response> createTeam(
    String teamName, String description, bool visibility, String token) async {
  String url = baseUrl + "team/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = '{"name": "' +
      teamName +
      '","description": "' +
      description +
      '","visible": ' +
      visibility.toString() +
      '}';
  final response = await http.post(url, headers: headers, body: body); //patch?
  return response;
}

Future<http.Response> editTeam(
    String teamName, String description, bool visibility, String token) async {
  String url = baseUrl + "team/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = '{"name": "' +
      teamName +
      '","description": "' +
      description +
      '","visible": ' +
      visibility.toString() +
      '}';
  final response = await http.patch(url, headers: headers, body: body); //patch?
  return response;
}

Future<bool> promoteToAdmin(String userID, String token) async {
  String url =
      baseUrl + "team/promote/" + userID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers);
  if (response.statusCode == 200) {
    return true;
  } else {
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
    Team team = Team.fromJson(parsedJson);
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
    return data;
  }
  return null;
}

Future<void> acceptRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/accept/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  await http.post(url, headers: headers);
}

Future<void> cancelRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/cancel/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  await http.post(url, headers: headers);
}

Future<void> declineRequest(String token, String requestID) async {
  String url =
      baseUrl + "requests/cancel/" + requestID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  await http.post(url, headers: headers);
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
    return data;
  }
  return null;
}

Future<void> inviteTeamMember(String userEmail, String token) async {
  const url = baseUrl + "team/invite";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json.encode({'email': userEmail});
  await http.post(url, headers: headers, body: body);
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
    return;
  }
}

Future<bool> requestTeam(String teamID, String token) async {
  String url = baseUrl + "team/join/" + teamID;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    return true;
  }
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
    return true;
  }
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
  await http.patch(url, headers: headers, body: body); //patch?
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
    Team team = Team.fromJson(data);
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
  print(token);
  final response = await http.get(url, headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> teamStrings = List.from(jsonDecode(response.body));
    List<Team> teamsList = [];
    for (int i = 0; i < teamStrings.length; i++) {
      teamsList.add(Team.fromJson(teamStrings[i]));
    }
    return teamsList;
  }
  return null;
}

//getStudents (in api) for the format of the request (particiants)
//getTeam () for the mapping
Future<List<Team>> teamSearch(String token, String query) async {
  //this is from the swagger
  String url = baseUrl + "/teams/search?name=" + query;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  //copied from getTeams (above)
  //print(token);

  //look at swagger -H is the headers
  final response = await http.get(url, headers: headers);
  //print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> teamStrings = List.from(jsonDecode(response.body));
    List<Team> teamsList = [];
    for (int i = 0; i < teamStrings.length; i++) {
      teamsList.add(Team.fromJsonSearch(teamStrings[i]));
    }
    return teamsList;
  }
  return null;
}
