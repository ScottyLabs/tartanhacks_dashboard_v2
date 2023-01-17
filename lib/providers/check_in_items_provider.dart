import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart' as api;
import 'package:thdapp/models/check_in_item.dart';

enum Status {
  notLoaded,
  fetching,
  loaded,
  error
}

class CheckInItemsModel with ChangeNotifier {
  Status _status = Status.notLoaded;
  String _token = "";
  String _uid = "";

  List<CheckInItem> _list;
  Map<String, bool> hasCheckedIn;

  bool isAdmin;
  int points;

  Status get checkInItemsStatus => _status;
  List get checkInItems => _list;
  String get userID => _uid;

  void handleException(e) {
    _list = [];
    _status = Status.error;
    notifyListeners();
  }

  Future<void> fetchCheckInItems() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = prefs.getString("token");
    _uid = prefs.getString("id");
    isAdmin = prefs.getBool("admin");
    _status = Status.fetching;

    try {
      if (isAdmin) {
        _list = await api.getCheckInItems();
        hasCheckedIn = null;
        points = 0;
      } else {
        List history = await api.getUserHistory(prefs.getString("id"), _token);
        points = history[0];
        hasCheckedIn = history[1];
        _list = history[2];
      }
      _status = Status.loaded;
      notifyListeners();

    } on Exception catch (e) {
      handleException(e);
    }
  }

  Future<void> addCheckInItem(CheckInItemDTO item) async {
    await api.addCheckInItem(item, _token);
    await fetchCheckInItems();
  }

  Future<void> deleteCheckInItem(String id) async {
    await api.deleteCheckInItem(id, _token);
    await fetchCheckInItems();
  }

  Future<void> editCheckInItem(CheckInItemDTO item, String id) async {
    await api.editCheckInItem(item, id, _token);
    await fetchCheckInItems();
  }

  Future<void> checkInUser(String id, String uid) async {
    await api.checkInUser(id, uid, _token);
  }

  Future<void> selfCheckIn(String id) async {
    await api.checkInUser(id, _uid, _token);
    await fetchCheckInItems();
  }

  void reset() {
    _status = Status.notLoaded;
    _list = null;
    _uid = "";
    hasCheckedIn = null;
    notifyListeners();
  }
}