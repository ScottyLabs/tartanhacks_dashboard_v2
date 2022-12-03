import 'package:flutter/cupertino.dart';
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
import 'models/project.dart';
import 'models/team.dart';
import 'pages/custom_widgets.dart';
import 'models/discord.dart';

SharedPreferences prefs;

const baseUrl = "https://dev.backend.tartanhacks.com/";

Future<User> checkCredentials(String email, String password) async {
  String url = baseUrl + "auth/login";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    User loginData;
    var data = json.decode(response.body);
    loginData = User.fromJson(data);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.token);
    prefs.setString('email', loginData.email);
    prefs.setString('password', password);
    prefs.setBool('admin', loginData.admin);
    prefs.setString('id', loginData.id);
    prefs.setString('company', loginData.company);

    return loginData;
  } else {
    return null;
  }
}

Future<bool> resetPassword(String email) async {
  String url = baseUrl + "auth/request-reset";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Profile> getProfile(String id, String token) async {
  String url = baseUrl + "users/" + id + "/profile";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Profile profile = Profile.fromJson(data);
    print(data);
    // profile.picture = "lib/logos/defaultpfp.PNG";
    return profile;
  } else {
    return null;
  }
}

Future<bool> checkNameAvailable(String name, String token) async {
  String url = baseUrl + "user/name/available";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = json.encode({"name": name});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data;
  } else {
    return null;
  }
}

Future<bool> setDisplayName(String name, String token) async {
  bool isAvailable = await checkNameAvailable(name, token);
  if (isAvailable != true) {
    return isAvailable;
  }

  String url = baseUrl + "user/profile";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = json.encode({"displayName": name});

  final response = await http.put(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    return null;
  }
}

Future<List> getStudents(String token, {String query}) async {
  String url = baseUrl + "participants";
  if (query != null) {
    url = url + "?name=" + query;
  }
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var ids = data.map((json) => json['_id']).toList();
    List profs = data.map((json) => Profile.fromJson(json['profile'])).toList();
    List teams = data
        .map((json) => (json['team'] != null) ? json['team']['name'] : null)
        .toList();
    return [ids, profs, teams];
  }
  return null;
}

Future<Map> getBookmarkIdsList(String token) async {
  var bookmarks = {};
  List bookmarkIds;
  List bmParticipantIds;
  String url = baseUrl + "bookmarks/participant";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    bookmarkIds = data.map((json) => json['_id']).toList();
    var bookmarkedParticipants =
        data.map((json) => json['participant']).toList();
    bmParticipantIds =
        bookmarkedParticipants.map((json) => json['_id']).toList();
    for (var i = 0; i < bookmarkIds.length; i++) {
      bookmarks[bookmarkIds[i]] = bmParticipantIds[i];
    }
    return bookmarks;
  }
  return null;
}

Future<List<ParticipantBookmark>> getParticipantBookmarks(String token) async {
  String url = baseUrl + "bookmarks/participant";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    data = data.map((bm) => ParticipantBookmark.fromJson(bm)).toList();
    return data;
  }
  return null;
}

Future<List<ProjectBookmark>> getProjectBookmarks(String token) async {
  String url = baseUrl + "bookmarks/project";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    data = data.map((bm) => ProjectBookmark.fromJson(bm)).toList();
    return data;
  }
  return null;
}

Future<void> deleteBookmark(String token, String id) async {
  String url = baseUrl + "bookmark/" + id;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  await http.delete(url, headers: headers);
}

Future<String> addBookmark(String token, String participantId) async {
  String url = baseUrl + "bookmark";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  String jsonInput = '{"bookmarkType": "PARTICIPANT", "participant":"' +
      participantId.toString() +
      '", "project":null, "description": "sample description"}';
  final response = await http.post(url, headers: headers, body: jsonInput);

  if (response.statusCode != 200) {
    return null;
  } else {
    Map<String, dynamic> data =
        Map<String, dynamic>.from(json.decode(response.body));
    var bookmarkId = data["_id"];
    return bookmarkId;
  }
}

Future<List<List<Event>>> getEvents() async {
  var url = baseUrl + 'schedule/';
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List<Event> eventsList;
    var data = json.decode(response.body) as List;
    eventsList = data.map<Event>((json) => Event.fromJson(json)).toList();
    List<Event> pastEvents = [];
    List<Event> upcomingEvents = [];
    var currentTime = DateTime.now().microsecondsSinceEpoch;

    for (int i = 0; i < eventsList.length; i++) {
      if (currentTime > eventsList[i].endTime) {
        pastEvents.insert(0, eventsList[i]);
      } else {
        upcomingEvents.add(eventsList[i]);
      }
    }
    return [upcomingEvents, pastEvents];
  } else {
    return null;
  }
}

Future<bool> addEvent(
    String name,
    String description,
    int startTime,
    int endTime,
    String location,
    double lat,
    double lng,
    String platform,
    String platformUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "schedule/";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  // String essayQuestionsAgg = "";
  // for (int i = 0; i < essayQuestions.length; i++) {
  //   essayQuestionsAgg += essayQuestions[i] + "\n";
  // }
  String bodyJson = '{"name":"' +
      name +
      '","description":"' +
      description +
      '","startTime":' +
      startTime.toString() +
      ',"endTime":' +
      endTime.toString() +
      ',"location":"' +
      location +
      '","lat":' +
      lat.toString() +
      ',"lng":' +
      lng.toString() +
      ',"platform":"' +
      platform +
      '","platformUrl":"' +
      platformUrl +
      '"}';

  final response = await http.post(url, headers: headers, body: bodyJson);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return addEvent(name, description, startTime, endTime, location, lat, lng,
        platform, platformUrl);
  } else {
    return false;
  }
}

Future<bool> editEvent(
    String eventId,
    String name,
    String description,
    int startTime,
    int endTime,
    String location,
    double lat,
    double lng,
    String platform,
    String platformUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "schedule/" + eventId;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String bodyJson = json.encode({
    "name": name,
    "description": description,
    "startTime": startTime.toString(),
    "endTime": endTime.toString(),
    "location": location,
    "lat": lat.toString(),
    "lng": lng.toString(),
    "platform": platform,
    "platformUrl": platformUrl
  });

  final response = await http.patch(url, headers: headers, body: bodyJson);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return editEvent(eventId, name, description, startTime, endTime, location,
        lat, lng, platform, platformUrl);
  } else {
    return false;
  }
}

Future<bool> deleteEvent(String eventId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");

  String url = baseUrl + "schedule/" + eventId;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  final response = await http.delete(url, headers: headers);
  if (response.statusCode == 200) {
    return true;
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
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonHistory = json.decode(response.body);
    List result = [
      jsonHistory['totalPoints'],
      <String, bool>{},
      <CheckInItem>[]
    ];

    jsonHistory['history'].forEach((val) {
      CheckInItem item = CheckInItem.fromJson(val['checkInItem']);
      result[2].add(item);
      result[1][item.id] = val['hasCheckedIn'] as bool;
    });
    return result;
  } else {
    throw Exception("Failed to fetch user $userID history");
  }
}

Future<void> addCheckInItem(CheckInItemDTO item, String token) async {
  String url = baseUrl + "check-in";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.post(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<void> editCheckInItem(
    CheckInItemDTO item, String id, String token) async {
  String url = baseUrl + "check-in/$id";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.patch(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to edit Check In Item");
  }
}

Future<void> deleteCheckInItem(String id, String token) async {
  String url = baseUrl + "check-in/$id";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.patch(url, headers: headers);

  if (response.statusCode != 200) {
    throw Exception("Failed to delete Check In Item");
  }
}

Future<void> checkInUser(String id, String uid, token) async {
  String base = baseUrl.replaceAll("https://", "").replaceAll("/", "");
  final queryParams = {'userID': uid, 'checkInItemID': id};
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final uri = Uri.https(base, "/check-in/user", queryParams);
  final response = await http.put(uri, headers: headers);

  if (response.statusCode != 200) {
    Map<String, dynamic> error = jsonDecode(response.body);
    String msg = error['message'].toString();
    if (msg.length<=2) {
      msg = "We encountered an error while checking you in.";
    }
    throw Exception(msg);
  }
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
    List<LBEntry> lb =
        data.map<LBEntry>((json) => LBEntry.fromJson(json)).toList();
    return lb;
  } else {
    return null;
  }
}

Future<int> getSelfRank(String token) async {
  String url = baseUrl + "leaderboard/rank";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data;
  } else {
    return null;
  }
}

Future<List<Prize>> getPrizes() async {
  String url = baseUrl + "prizes";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<Prize> prizes =
        data.map<Prize>((json) => Prize.fromJson(json)).toList();
    return prizes;
  } else {
    return null;
  }
}

Future<Project> getProject(String id, String token) async {
  String url = baseUrl + "users/" + id + "/project";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Project project = Project.fromJson(data);
    return project;
  } else {
    return null;
  }
}

Future<Project> newProject(
    BuildContext context,
    String name,
    String desc,
    String teamId,
    String slides,
    String video,
    String ghurl,
    bool isVirtual,
    String id,
    String token) async {
  String url = baseUrl + "projects";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = json.encode({
    "name": name,
    "description": desc,
    "team": teamId,
    "slides": slides,
    "video": video,
    "url": ghurl,
    "presentingVirtually": isVirtual
  });
  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Project project = Project.fromJson(data);
    return project;
  } else {
    return Future.error("Error");
  }
}

Future<Project> editProject(
    BuildContext context,
    String name,
    String desc,
    String slides,
    String video,
    String ghurl,
    bool isVirtual,
    String id,
    String token) async {
  String url = baseUrl + "projects/" + id;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  String body = json.encode({
    "name": name,
    "description": desc,
    "slides": slides,
    "video": video,
    "url": ghurl,
    "presentingVirtually": isVirtual
  });
  final response = await http.patch(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Project project = Project.fromJson(data);
    return project;
  } else {
    return Future.error("Error");
    //errorDialog(context, "Error", json.decode(response.body)['message']);
  }
}

Future enterPrize(
    BuildContext context, String projId, String prizeId, String token) async {
  String url =
      baseUrl + "projects/prizes/enter/" + projId + "?prizeID=" + prizeId;
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.put(url, headers: headers);

  if (response.statusCode == 200) {
    errorDialog(context, "Success", "Successfully entered for prize.");
    return true;
  } else {
    errorDialog(context, "Error", json.decode(response.body)['message']);
    return false;
  }
}

Future<Team> getTeamById(String id, String token) async {
  String url = baseUrl + "users/" + id + "/team";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Team team = Team.fromJson(data);
    return team;
  } else {
    return null;
  }
}

Future<DiscordInfo> getDiscordInfo(String token) async {
  String url = baseUrl + 'user/verification';
  Map<String, String> headers = {
    "Content-type": "application/json",
    "x-access-token": token
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    DiscordInfo discord = DiscordInfo.fromJson(data);
    return discord;
  } else {
    return null;
  }
}
