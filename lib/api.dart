import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/check_in_item.dart';
import 'models/profile.dart';
import 'models/event.dart';
import 'models/user.dart';
import 'models/participant_bookmark.dart';
import 'models/project_bookmark.dart';
import 'models/lb_entry.dart';
import 'models/prize.dart';

SharedPreferences prefs;

const baseUrl = "https://tartanhacks-backend.herokuapp.com/";

Future<User> checkCredentials(String email, String password) async {
  String url = baseUrl + "auth/login";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    User loginData;
    var data = json.decode(response.body);
    loginData = new User.fromJson(data);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.token);
    prefs.setString('email', loginData.email);
    prefs.setString('password', password);
    prefs.setBool('admin', loginData.admin);
    prefs.setString('id', loginData.id);
    prefs.setString('company', loginData.company);

    return loginData;
  } else {
    print(json1);
    return null;
  }
}

Future<String> resetPassword(String email) async {
  String url = baseUrl + "auth/regiset";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    return "Please check your email address to reset your password.";
  } else {
    return "We encountered an error while resetting your password. Please contact ScottyLabs for help";
  }
}

Future<Profile> getProfile(String id, String token) async {
  String url = baseUrl + "users/" + id + "/profile";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Profile profile = new Profile.fromJson(data);
    return profile;
  } else {
    print(token);
    print(response.body.toString());
    return null;
  }
}

Future<List> getStudents(String token) async {
  List listOfUsers = [];
  String url = baseUrl + "users";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if(response.statusCode == 200) {
    var data = json.decode(response.body);
    var ids = data.map ((json) => json['_id']).toList();
    for (String id in ids) {
      Profile prof = await getProfile(id, token);
      listOfUsers.add(prof);
    }
    return [ids, listOfUsers];
  }
}

Future<Map> getBookmarkIdsList(String token) async {
  var bookmarks = new Map();
  List bookmarkIds;
  List bmParticipantIds;
  String url = baseUrl + "bookmarks/participant";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers:headers);

  if(response.statusCode == 200) {
    var data = json.decode(response.body);
    bookmarkIds = data.map ((json) => json['_id']).toList();
    var bookmarkedParticipants = data.map ((json) => json['participant']).toList();
    bmParticipantIds = bookmarkedParticipants.map ((json) => json['_id']).toList();
    for (var i = 0; i < bookmarkIds.length; i++) {
      bookmarks[bookmarkIds[i]] = bmParticipantIds[i];
    }
    return bookmarks;
  }
}

Future<List<ParticipantBookmark>> getParticipantBookmarks(String token) async {
  List participantBookmarks = [];
  String url = baseUrl + "bookmarks/participant";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    ParticipantBookmark temp = new ParticipantBookmark.fromJson(data);
    participantBookmarks.add(temp);
    return participantBookmarks;
  }
  else {
    print('error getting participant bookmarks');
  }
}

Future<List<ProjectBookmark>> getProjectBookmarks(String token) async {
  List projectBookmarks = [];
  String url = baseUrl + "bookmarks/project";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    ProjectBookmark temp = new ProjectBookmark.fromJson(data);
    projectBookmarks.add(temp);
    return projectBookmarks;
  }
  else {
    print('error getting project bookmarks');
  }
}

Future<void> deleteBookmark(String token, String id) async {
  String url = baseUrl + "bookmark/" + id;
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.delete(url, headers:headers);

  if(response.statusCode != 200) {
    print('Failed to delete bookmark ' + id + ' with code ' + response.statusCode.toString());
  }
  else {
    print('Successfully deleted bookmark ' + id);
  }
}

Future<String> addBookmark(String token, String participantId) async {
  String url = baseUrl + "bookmark";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  String jsonInput = '{"bookmarkType": "PARTICIPANT", "participant":"' + participantId + ', "project":"sample project", "description": "sample description""}';
  final response = await http.post(url, headers: headers, body: jsonInput);

  if(response.statusCode != 200) {
    print('Failed to add bookmark with participant ' + participantId);
  }
  else {
    print('Successfully added bookmark');
    var data = json.decode(response.body);
    var bookmarkId = data.map((json) => json['_id']).toString();
    print(bookmarkId);
    return bookmarkId;
  }
}

Future<List<Event>> getEvents() async {
  var url = baseUrl+'events/get';
  final response = await http.post(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    List<Event> eventsList;
    var data = json.decode(response.body) as List;
    eventsList = data.map<Event> ((json) => Event.fromJson(json)).toList();
    return eventsList;
  }else{
    return null;
  }
}

Future<bool> addEvents(String name, String description, String startTime, String endTime, bool enableCheckin, bool enableProjects, bool enableTeams, bool enableSponsors, String logoUrl, List<String> essayQuestions) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/new";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Token": token
  };

  String essayQuestionsAgg = "";
  for (int i = 0; i < essayQuestions.length; i++) {
    essayQuestionsAgg += essayQuestions[i] + "\n";
  }
  String json1 = '{"name":"' + name +
      '","description":"' + description +
      '","startTime":"' + startTime +
      '","endTime":"' + endTime +
      ', "enableCheckin": true, "enableProjects": true, "enableTeams": true, "enableSponsors": true,' +
      '","logoUrl":"' + logoUrl +
      '"essayQuestions":"' + essayQuestionsAgg + '}';
  print(json1);
  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return addEvents(
        name,
        description,
        startTime,
        endTime,
        enableCheckin,
        enableProjects,
        enableTeams,
        enableSponsors,
        logoUrl,
        essayQuestions);
  } else {
    return false;
  }
}

// Check In Endpoints
Future<List<CheckInItem>> getCheckInItems() async {
  String url = baseUrl + "check-in";
  Map<String, String> headers = {"Content-type": "application/json"};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((e) => CheckInItem.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch Check In data");
  }
}

/*
0 - (int) user points
1 - Map<String checkInItem ID, bool hasCheckedIn>
2 - List<CheckInItem>
 */
Future<List> getUserHistory(String userID, String token) async {
  String url = baseUrl + "check-in/history/$userID";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonHistory = json.decode(response.body);
    List result = [jsonHistory['totalPoints'], Map<String, bool>() , <CheckInItem>[]];

    jsonHistory['history'].forEach((val) {
      CheckInItem item = CheckInItem.fromJson(val['checkInItem']);
      result[2].add(item);
      result[1][item.id] = val['hasCheckedIn'] as bool;
    });
    print(result[1]);
    return result;
  } else {
    throw Exception("Failed to fetch user $userID history");
  }
}

Future<void> addCheckInItem(CheckInItemDTO item, String token) async {
  String url = baseUrl + "check-in";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.post(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<void> editCheckInItem(CheckInItemDTO item, String id, String token) async {
  String url = baseUrl + "check-in/$id";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.patch(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to edit Check In Item");
  }
}

Future<void> deleteCheckInItem(String id, String token) async {
  String url = baseUrl + "check-in/$id";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.patch(url, headers: headers);

  if (response.statusCode != 200) {
    throw Exception("Failed to delete Check In Item");
  }
}

Future<void> checkInUser(String id, String uid, token) async {
  String base = baseUrl.replaceAll("https://", "").replaceAll("/", "");
  final queryParams = {
    'userID': uid,
    'checkInItemID': id
  };
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final uri = Uri.http(base, "/check-in/user", queryParams);
  final response = await http.put(uri, headers: headers);

  // TODO Error with backend, throws a 400 despite successful update
  // if (response.statusCode != 200) {
  //   throw Exception(response.body.toString());
  // }
}

Future<String> getCurrentUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("id");
}

Future<List<LBEntry>> getLeaderboard() async {
  String url = baseUrl + "leaderboard";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<LBEntry> lb = data.map<LBEntry>((json) => LBEntry.fromJson(json)).toList();
    return lb;
  } else {
    print(response.body.toString());
    return null;
  }
}

Future<int> getSelfRank(String token) async {
  String url = baseUrl + "leaderboard/rank";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data;
  } else {
    print(response.body.toString());
    return null;
  }
}

Future<List<Prize>> getPrizes() async {
  String url = baseUrl + "prizes";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<Prize> prizes = data.map<Prize>((json) => Prize.fromJson(json)).toList();
    return prizes;
  } else {
    print(response.body.toString());
    return null;
  }
}