import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/check_in_item.dart';
import 'models/profile.dart';
import 'models/user.dart';

SharedPreferences prefs;

const baseUrl = "https://tartanhacks-backend.herokuapp.com/";
const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGNkNzRmMmJmYWQ2MTNhODEwYTMzMDIiLCJpYXQiOjE2MzU2MDk4MzksImV4cCI6MTYzNzMzNzgzOX0._5K4sqsFhJbF58-skYaBwkqqANYITYCo6_EcxUTTWqY";

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

Future<void> addCheckInItem(CheckInItem item) async {
  String url = baseUrl + "check-in";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.post(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<void> editCheckInItem(CheckInItem item) async {
  String url = baseUrl + "check-in/${item.id}";
  String itemJson = jsonEncode(item);
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.patch(url, headers: headers, body: itemJson);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<void> deleteCheckInItem(CheckInItem item) async {
  String url = baseUrl + "check-in/${item.id}";
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.patch(url, headers: headers);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<void> checkInUser(CheckInItem item, String uid) async {
  final queryParams = {
    'userID': uid,
    'checkInItemID': item.id
  };
  Map<String, String> headers = {"Content-type": "application/json"};
  final uri = Uri.http(baseUrl, "check-in/user", queryParams);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode != 200) {
    throw Exception("Failed to add Check In Item");
  }
}

Future<List<Profile>> getLeaderboard(String token) async {
  String url = baseUrl + "check-in/leaderboard";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<Profile> lb = [];
    var data = json.decode(response.body);
    var ids = data.map ((json) => json['user']).toList();
    print(ids);
    for (String i in ids) {
      Profile prof = await getProfile(i, token);
      lb.add(prof);
    }
    print(lb);
    return lb;
  } else {
    print(response.body.toString());
    return null;
  }
}
