import 'package:flutter/material.dart';
import 'package:koe/common/download_manager.dart';
import 'package:get/get.dart';

class DownloadManagerState {
  static final tasks = {}.obs;
}

class DownloadManagerView extends StatelessWidget {
  DownloadManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("下载管理"),
        ),
        body: Container(
            child: Column(
                children: DownloadManagerState.tasks
                    .map((key, value) => MapEntry(
                        key,
                        Obx(() => ListTile(
                              title: Text(value["savename"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.subtitle1),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: value["received"] / value["total"],
                                    minHeight: 2,
                                  ),
                                  Text(
                                      "${(value["received"] / 1024 / 1024).toStringAsFixed(2)}MB / ${(value["total"] / 1024 / 1024).toStringAsFixed(2)}MB",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.caption)
                                ],
                              ),
                            ))))
                    .values
                    .toList())));
  }
}
