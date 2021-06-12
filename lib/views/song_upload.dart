import 'package:dart_tags/dart_tags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:koe/common/api.dart';

class SongUploadView extends StatefulWidget {
  SongUploadView({Key? key}) : super(key: key);

  @override
  _SongUploadViewState createState() => _SongUploadViewState();
}

class _SongUploadViewState extends State<SongUploadView> {
  var songs = {}.obs;
  get ss => songs
      .map((key, value) {
        return MapEntry(
            key,
            Card(
                child: ListTile(
              title: Text(value["tags"]["title"],
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onLongPress: () async {},
              subtitle: Text("${value["tags"]["artist"]}"),
              trailing: Checkbox(
                value: songs[key]["checked"].value,
                onChanged: (value) {
                  songs[key]["checked"].value = value;
                  print(songs[key]["checked"]);
                },
              ),
            )));
      })
      .values
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("上传"),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.expand_less,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).accentIconTheme.color,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.red[400],
                foregroundColor: Theme.of(context).accentIconTheme.color,
                onTap: () async {
                  var result = await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                      allowMultiple: true,
                      withData: true);

                  if (result != null) {
                    TagProcessor tp = new TagProcessor();

                    result.files.forEach((f) => tp
                        .getTagsFromByteArray(Future.value(f.bytes))
                        .then((l) => l.forEach((it) {
                              if (it.version == "1.1" && it.tags.isEmpty) {
                                return;
                              }
                              // print(it.type);
                              if (it.tags.isNotEmpty) {
                                songs[it.tags["title"]] = {};
                                songs[it.tags["title"]]["tags"] = it.tags;
                                songs[it.tags["title"]]["checked"] = false.obs;
                                songs[it.tags["title"]]["filename"] =
                                    "${f.name}.${f.extension}";
                                songs[it.tags["title"]]["data"] = f.bytes;
                                print(it.tags["artist"].split("/"));
                              } else {}
                            })));
                  } else {
                    // User canceled the picker
                  }
                }),
            SpeedDialChild(
                child: Icon(Icons.edit),
                backgroundColor: Colors.indigo[400],
                foregroundColor: Theme.of(context).accentIconTheme.color,
                onTap: () async {
                  var result = await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                      allowMultiple: true,
                      withData: true);

                  if (result != null) {
                    TagProcessor tp = new TagProcessor();

                    result.files.forEach((f) => tp
                        .getTagsFromByteArray(Future.value(f.bytes))
                        .then((l) => l.forEach((it) {
                              if (it.version == "1.1" && it.tags.isEmpty) {
                                return;
                              }
                              // print(it.type);
                              if (it.tags.isNotEmpty) {
                                songs[it.tags["title"]] = {};
                                songs[it.tags["title"]]["tags"] = it.tags;
                                songs[it.tags["title"]]["checked"] = false.obs;
                                print(it.tags["artist"].split("/"));
                              } else {}
                            })));
                  } else {
                    // User canceled the picker
                  }
                }),
            SpeedDialChild(
                child: Icon(Icons.cloud_upload),
                backgroundColor: Colors.teal[400],
                foregroundColor: Theme.of(context).accentIconTheme.color,
                onTap: () async {
                  songs.forEach((key, value) async {
                    if (value["checked"].value) {
                      print(value);
                      var res = (await Api.uploadFile(value["data"],
                          value["filename"], "audio/any"))["data"];

                      if (res.length != 0) {
                        var data = res[0];

                        switch (data["code"]) {
                          case 200:
                            await Api.createSongFromMeta(
                                value["tags"]["artist"].split("/"),
                                value["tags"]["album"],
                                key,
                                data["file_id"]);
                            break;
                          case 400:
                            // File already uploaded
                            break;
                          default:
                            // Unknown error
                            break;
                        }
                      }
                    }
                  });
                })
          ],
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(6),
          child: Obx(() => Column(
                children: ss,
              )),
        )));
  }
}
