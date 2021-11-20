import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
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
    notifyListeners();
    try {
      _list = await getCheckInItems();
      _status = Status.Loaded;
      notifyListeners();
    } on Exception catch (e) {
      handleException(e);
    }
  }

  Future<void> addCheckInItem(CheckInItem item) async {
    addCheckInItem(item);
    fetchCheckInItems();
  }

  Future<void> deleteCheckInItem(CheckInItem item) async {
    deleteCheckInItem(item);
    fetchCheckInItems();
  }

  Future<void> editCheckInItem(CheckInItem item) async {
    editCheckInItem(item);
    fetchCheckInItems();
  }
}