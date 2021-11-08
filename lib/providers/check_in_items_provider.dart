import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thdapp/api.dart' as api;
import 'package:thdapp/models/check_in_item.dart';

enum Status {
  NotLoaded,
  Fetching,
  Loaded,
  Error
}

class CheckInItemsModel with ChangeNotifier {
  Status _status = Status.NotLoaded;
  List<CheckInItem> _list;

  Status get checkInItemsStatus => _status;
  List get checkInItems=> _list;

  void handleException(e) {
    print(e);
    _list = [];
    _status = Status.Error;
    notifyListeners();
  }

  Future<void> fetchCheckInItems() async {
    _status = Status.Fetching;
    try {
      _list = await api.getCheckInItems();
      _status = Status.Loaded;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      handleException(e);
    }
  }

  Future<void> addCheckInItem(CheckInItemDTO item) async {
    await api.addCheckInItem(item);
    await fetchCheckInItems();
  }

  Future<void> deleteCheckInItem(String id) async {
    await api.deleteCheckInItem(id);
    await fetchCheckInItems();
  }

  Future<void> editCheckInItem(CheckInItemDTO item, String id) async {
    await api.editCheckInItem(item, id);
    await fetchCheckInItems();
  }
}