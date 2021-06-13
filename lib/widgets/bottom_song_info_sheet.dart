import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koe/common/api.dart';
import 'package:koe/common/download_manager.dart'
    if (dart.library.html) 'package:koe/common/download_manager_web.dart';
import 'package:koe/models/model.dart';

class BottomSongInfoSheet extends StatelessWidget {
  final Song song;

  const BottomSongInfoSheet(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Card(
            child: Row(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: Image(
                  width: 100,
                  height: 100,
                  image: NetworkImage(song.coverFiles?.length != 0
                      ? Api.API_GET_FILE
                          .replaceAll("{file_id}", song.coverFiles![0].id!)
                      : "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3761843179,3646757056&fm=26&gp=0.jpg"))),
          SizedBox(
            width: 4,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("${song.title}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 4,
                ),
                Text("${song.artists!.map((x) => x.name).join("/")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.caption),
                SizedBox(
                  height: 4,
                ),
                Text("${song.album!.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle2)
              ]),
        ])),
        Divider(),
        Card(
          child: Column(
            children: [
              ListTile(
                  title: Text("添加到播放列表"), leading: Icon(Icons.playlist_add)),
              ListTile(
                title: Text("收藏"),
                leading: Icon(Icons.favorite),
              ),
              ListTile(
                title: Text("下载"),
                leading: Icon(Icons.file_download),
                onTap: () async {
                  compute((_) {
                    Get.rawSnackbar(
                        title: "下载管理",
                        message:
                            "开始下载 ${song.artists!.map((x) => x.name).join("/")} - ${song.title}");
                    DownloadManager.download(
                        song.audioFiles![0].id!,
                        "${song.artists!.map((x) => x.name).join("/")} - ${song.title}",
                        (a, b) {},
                        (_) => {
                              Get.rawSnackbar(
                                  title: "下载管理",
                                  message:
                                      "${song.artists!.map((x) => x.name).join("/")} - ${song.title} 下载成功")
                            });
                  }, "");
                },
              ),
              ListTile(title: Text("分享歌曲"), leading: Icon(Icons.share)),
              ListTile(
                title: Text("歌曲信息"),
                leading: Icon(Icons.info),
              )
            ],
          ),
        )
      ],
    ));
  }
}
