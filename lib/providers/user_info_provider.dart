import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/profile.dart';
import 'package:thdapp/models/team.dart';
import 'package:thdapp/pages/team_api.dart';

enum Status {
  notLoaded,
  fetching,
  loaded,
  error
}

class UserInfoModel with ChangeNotifier {
  Status _status = Status.notLoaded;
  String _token = "";
  String _uid = "";

  Profile userProfile = null;
  Team team = null;
  bool hasTeam = false;
  bool isAdmin = false;

  Status get userInfoStatus => _status;

  void handleException(e) {
    _status = Status.error;
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = prefs.getString("token");
    _uid = prefs.getString("id");
    isAdmin = prefs.getBool("admin");
    if (_status == Status.notLoaded) {
      _status = Status.fetching;
    }

    try {
      userProfile = await getProfile(_uid, _token);
      team = await getUserTeam(_token);
      hasTeam = team != null;
      _status = Status.loaded;
      notifyListeners();
    } on Exception catch(e) {
      handleException(e);
    }
  }

  void reset() {
    Status _status = Status.notLoaded;
    String _token = "";
    String _uid = "";

    Profile userProfile = null;
    Team team = null;
    bool hasTeam = false;
    bool isAdmin = false;
  }
}