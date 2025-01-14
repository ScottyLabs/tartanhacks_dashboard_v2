import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/pages/login.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'package:thdapp/providers/user_info_provider.dart';

void logOut(entry, context) async {
  var prefs = await SharedPreferences.getInstance();
  String theme = prefs.getString("theme") ?? "dark";
  await prefs.clear();
  prefs.setString("theme", theme);
  entry.remove();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctxt) => Login()),
          (route) => false
  );
  Provider.of<CheckInItemsModel>(context, listen: false).reset();
  Provider.of<UserInfoModel>(context, listen: false).reset();
}

void setThemePref(theme, entry, context) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("theme", theme);
}