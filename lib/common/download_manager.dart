import 'dart:async';
import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/foundation.dart';

import 'api.dart';
import 'global.dart';

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

  //final stateStream = Stream<DownloadTaskState>.empty().asBroadcastStream();
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

  DownloaderCore? _ftask;

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
      final downloaderUtils = DownloaderUtils(
        client: Api.httpClient,
        progressCallback: (received, total) {
          progressStreamController.add(DownloadTaskProgress(received, total));
        },
        file: File('${await Global.appDirectory}/musics/$saveName.$ext'),
        progress: ProgressImplementation(),
        onDone: () {
          state = DownloadTaskState.FINISHED;
          stateStreamController.add(state);
        },
        deleteOnCancel: true,
      );

      _ftask = await Flowder.download(url, downloaderUtils);
    });
  }

  pause() async {
    state = DownloadTaskState.PAUSED;
    stateStreamController.add(state);

    _ftask!.pause();
  }

  cancel() async {
    state = DownloadTaskState.TERMINATED;
    stateStreamController.add(state);

    _ftask!.cancel();
  }
}

class DownloadManager {
  static void download(
      String fileId, String saveName, onReceive, callback) async {
    var task = DownloadTask(fileId, saveName);
    await task.start();
  }
}
