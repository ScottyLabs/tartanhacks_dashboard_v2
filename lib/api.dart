import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/event_model.dart';
import 'models/prize.dart';
import 'models/project.dart';


SharedPreferences prefs;

const baseUrl = "https://thd-api.herokuapp.com/";

Future<Login> checkCredentials(String email, String password) async {
  String url = baseUrl + "auth/login";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    Login loginData;
    var data = json.decode(response.body);
    loginData = new Login.fromJson(data);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.access_token);
    prefs.setString('email', loginData.user.email);
    prefs.setString('password', password);
    prefs.setBool('is_admin', loginData.user.is_admin);
    prefs.setString('id', loginData.user.id);
    prefs.setString('team_id', loginData.user.team_id);

    return loginData;
  } else {
    print(json1);
    return null;
  }
}

Future<String> resetPassword(String email) async {
  print(email);
  String url = baseUrl + "auth/forgot";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  // need to fix for reset password. what is the base url
  if (response.statusCode == 200) {
    return "Please check your email address to reset your password.";
  } else {
    return "We encountered an error while resetting your password. Please contact ScottyLabs for help";
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

Future<bool> addEvents(String name, String unixTime, String description, String gcal, String zoom_link, int access_code, String zoom_id, String zoom_password, String duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/new";
  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  String json1 = '{"name":"' + name + '","timestamp":"' + unixTime + '","description":"' + description + '","zoom_access_enabled":true,"gcal_event_url":"' + gcal + '","zoom_link":"' + zoom_link + '","is_in_person":false,"access_code":' + access_code.toString() + ',"zoom_id":"' + zoom_id + '","zoom_password":"' + zoom_password + '","duration":' + duration + '}';
  print(json1);
  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    return true;
  }else if(response.statusCode == 401){
    refreshToken();
    return addEvents(name, unixTime, description, gcal, zoom_link, access_code, zoom_id, zoom_password, duration);
  }else{
    return false;
  }
}

Future<bool> editEvents(String eventId, String name, String unixTime, String description, String gcal, String zoom_link, int access_code, String zoom_id, String zoom_password, String duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/edit";
  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  String json1 = '{"_id":"'+eventId+'","name":"' + name + '","timestamp":"' + unixTime + '","description":"' + description + '","zoom_access_enabled":true,"gcal_event_url":"' + gcal + '","zoom_link":"' + zoom_link + '","is_in_person":false,"access_code":' + access_code.toString() + ',"zoom_id":"' + zoom_id + '","zoom_password":"' + zoom_password + '","duration":' + duration + '}';
  print(json1);
  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    return true;
  }else if(response.statusCode == 401){
    refreshToken();
    return addEvents(name, unixTime, description, gcal, zoom_link, access_code, zoom_id, zoom_password, duration);
  }else{
    return false;
  }
}


void refreshToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString("email");
  String password = prefs.getString("password");
  Login res = await checkCredentials(email, password);
}


Future<List<Prize>> getAllPrizes() async {
  const url = "https://thd-api.herokuapp.com/projects/prizes/get";
  final response = await http.post(url);

  if (response.statusCode == 200) {
    List<Prize> prizes;
    var jsonList = json.decode(response.body) as List;
    prizes = jsonList.map((i) => Prize.fromJson(i)).toList();
    print(prizes.toString);
    return prizes;
  }
  return null;
}

Future<Project> getProject(String teamID, String token, Function showDialog) async {

  const url = "https://thd-api.herokuapp.com/projects/get";
  var body = json.encode({'team_id' : teamID});

  print("printing team ID");
  print(teamID);

  print(body.toString());

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  final response = await http.post(url, headers: headers, body: body);

  print(response.body.toString());

  if (response.statusCode == 200) {
    print("response = 200");
    var jsonList = json.decode(response.body);
    print(jsonList.toString());
    if (jsonList.length == 0) {
      showDialog("Could not find an existing project", "No project found");
    }
    Project project = Project.fromJson(jsonList[0]);
    return project;
  }
  else if (response.statusCode == 401){
    showDialog("Please try logging out and back in", "Error accessing projects");
  }
  return null;
}

void enterProject(String projectID, String prizeId, String token, Function showDialog) async {
  String url = "https://thd-api.herokuapp.com/projects/";
  String new_url = url + "/prizes/enter" + "?project_id=" + projectID + "&prize_id=" + prizeId;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Token": token
  };

  var response = await http.get(new_url, headers: headers);
  if(response.statusCode != 200) {
    Map data = json.decode(response.body);
    showDialog(data['message'], "Submission Failed");
  }else{
    showDialog("Successfully submitted for prize", "Success!");
  }
}


Future<bool> editProject(String name, String desc, String teamID, String token, String github,
    String slides, String video, bool presenting, String id, Function showDialog) async {

  String url = "https://thd-api.herokuapp.com/projects/";
  String new_url = url + "/edit";

  print("printing id again");
  print(id);

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  var body = json.encode({'_id' : id, 'name' : name, 'desc' : desc, 'team_id' : teamID, 'github_url' : github, 'slides_url' : slides,
    'video_url' : video, 'will_present_live' : presenting});

  final response = await http.post(new_url, headers: headers, body: body);

  print(response.body.toString());

  if (response.statusCode == 200) {
    showDialog("Successfully saved project edits.", "Success");
    return true;
  }
  showDialog(json.decode(response.body)['message'], "Error");
  return false;
}

Future<bool> newProject(String name, String desc, String teamID, String token, String github,
    String slides, String video, bool presenting, String id, Function showDialog) async {

  String url = "https://thd-api.herokuapp.com/projects/";
  String new_url = url + "/new";

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  var body = json.encode({'name' : name, 'desc' : desc, 'team_id' : teamID, 'github_url' : github, 'slides_url' : slides,
    'video_url' : video, 'will_present_live' : presenting});

  final response = await http.post(new_url, headers: headers, body: body);

  if (response.statusCode == 200) {
    showDialog("Successfully created new project.", "Success");
    return true;
  }
  showDialog(json.decode(response.body)['message'], "Error");
  return false;
}
