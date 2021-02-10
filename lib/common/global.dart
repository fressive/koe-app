import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.orange
];

class Global {
  static SharedPreferences _prefs;
  static String _version = "1.0.0";

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}

abstract class Config {
  String key;
  dynamic value;
}

class AppConfig extends Config {
  @override
  String key;

  AppConfig(key) {
    this.key = key;
  }

  static final serverUrl = AppConfig("server_url");

  @override
  dynamic get value => Global._prefs.get(this.key);

  @override
  set value(dynamic value) {
    switch (value.runtimeType) {
      case double:
        Global._prefs.setDouble(key, value).then((value) => null);
        break;
      case int:
        Global._prefs.setInt(key, value).then((value) => null);
        break;
      case List:
        Global._prefs.setStringList(key, value).then((value) => null);
        break;
      case bool:
        Global._prefs.setBool(key, value).then((value) => null);
        break;
      default:
        Global._prefs.setString(key, value.toString()).then((value) => null);
    }
  }
}
