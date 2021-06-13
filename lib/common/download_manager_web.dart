import 'dart:async';
import 'dart:html' show window;
import 'dart:js' as js;
import 'dart:js';
import 'dart:js_util';

import 'package:flutter/foundation.dart';

import 'api.dart';

enum DownloadTaskState {
  IDLE,
  DOWNLOADING,
  PAUSED,
  FINISHED,
  ERROR,
  TERMINATED
}

class DownloadTaskProgress {
  const DownloadTaskProgress(this.received, this.total);

  final num received;
  final num total;
}

class DownloadTask {
  static final tasksStream = StreamController<DownloadTask>.broadcast();

  final stateStreamController = StreamController<DownloadTaskState>.broadcast();
  final progressStreamController =
      StreamController<DownloadTaskProgress>.broadcast();

  DownloadTask(this.fileId, this.saveName) {
    tasksStream.add(this);
  }

  final String fileId;
  final String saveName;

  var ext = "";
  var state = DownloadTaskState.IDLE;
  var progress = DownloadTaskProgress(-1, -1);

  jsProgressCallback(received, total) {
    progress = DownloadTaskProgress(received, total);
    progressStreamController.add(progress);
  }

  doneCallback() {
    state = DownloadTaskState.FINISHED;
    stateStreamController.add(state);
  }

  start() async {
    state = DownloadTaskState.DOWNLOADING;
    stateStreamController.add(state);

    var url = Api.API_GET_FILE.replaceAll("{file_id}", fileId);
    await Api.fetchFile(fileId).then((value) async {
      ext = value.extension!;
      setProperty(
          window, "progCallback$fileId", allowInterop(jsProgressCallback));
      setProperty(
          window, "finishedCallback$fileId", allowInterop(doneCallback));
      js.context.callMethod('start', [fileId, url, "", saveName, ext]);
    });
  }

  pause() async {
    state = DownloadTaskState.PAUSED;
    stateStreamController.add(state);
  }

  cancel() async {
    state = DownloadTaskState.TERMINATED;
    stateStreamController.add(state);
  }
}

class DownloadManager {
  static void download(
      String fileId, String saveName, onReceive, callback) async {
    var task = DownloadTask(fileId, saveName);
    await task.start();
  }
}
