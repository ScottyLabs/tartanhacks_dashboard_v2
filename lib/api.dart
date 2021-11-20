import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/profile.dart';
import 'models/user.dart';
import 'models/participant_bookmark.dart';
import 'models/project_bookmark.dart';

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
  String url = baseUrl + "user/profile/" + id;
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
    return null;
  }
  else {
    print('Successfully added bookmark');
    var data = json.decode(response.body);
    var bookmarkId = data.map((json) => json['_id']).toString();
    print(bookmarkId);
    return bookmarkId;
  }
}