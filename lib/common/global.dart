import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koe/common/player.dart';
import 'package:koe/views/download_manager_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

import 'download_manager.dart';

class Global {
  static late SharedPreferences _prefs;
  static late DefaultAudioHandler audioHandler;

  static String version = "1.0.0";
  static final themes = [
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.red,
    Colors.orange
  ];

  static get appDirectory async => await getApplicationDocumentsDirectory();

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    audioHandler = await AudioService.init(
      builder: () => DefaultAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelName: 'Koe',
        androidEnableQueue: true,
      ),
    );

    if (kIsWeb && AppConfig.serverUrl.value == null)
      AppConfig.serverUrl.value =
          "https://${Uri.base.host}${Uri.base.hasPort ? ':${Uri.base.port}' : ''}";

    DownloadTask.tasksStream.stream.listen((task) {
      DownloadManagerState.tasks[task.fileId] = {
        "state": task.state,
        "received": task.progress.received,
        "total": task.progress.total,
        "savename": task.saveName
      }.obs;

      task.stateStreamController.stream.listen((event) {
        DownloadManagerState.tasks[task.fileId]["state"] = event;
      });

      task.progressStreamController.stream.listen((event) {
        DownloadManagerState.tasks[task.fileId]["received"] = event.received;
        DownloadManagerState.tasks[task.fileId]["total"] = event.total;
      });
    });
  }
}

abstract class Config {
  @required
  final String key = "";

  dynamic value;
}

class AppConfig extends Config {
  AppConfig(String key);

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
