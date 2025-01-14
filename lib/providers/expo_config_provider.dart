import 'package:flutter/material.dart';
import '../models/config.dart';
import '../api.dart';

class ExpoConfigProvider with ChangeNotifier {
  ExpoConfig? _config;
  bool _loading = false;
  String? _error;

  ExpoConfig? get config => _config;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadConfig(String token) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _config = await getExpoConfig(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  bool canSubmitTableNumber() {
    if (_config == null) return false;
    return DateTime.now().isBefore(_config!.expoStartTime);
  }
} 