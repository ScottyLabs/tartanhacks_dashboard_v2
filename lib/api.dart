import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/profile.dart';
import 'models/event.dart';
import 'models/user.dart';

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
  String url = baseUrl + "auth/reset";
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

Future<List<Event>> getEvents() async {
  var url = baseUrl+'events/get';
  final response = await http.post(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    List<Event> EventsList;
    var data = json.decode(response.body) as List;
    EventsList = data.map<Event> ((json) => Event.fromJson(json)).toList();
    return EventsList;
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
  for(int i = 0; i < essayQuestions.length; i++){
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
