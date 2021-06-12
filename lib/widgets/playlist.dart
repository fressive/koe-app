import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:koe/common/global.dart';

import 'package:koe/models/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koe/widgets/bottom_song_info_sheet.dart';

class PlaylistController extends GetxController {
  var songs = <Song>[].obs;

  void updateSongs(songs) {
    this.songs.clear();
    this.songs.addAll(songs);
    update();
  }
}

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaylistController controller = Get.find();

    return Obx(() => SingleChildScrollView(
          child: Column(
              children: controller.songs
                  .map((e) => InkWell(
                        onTap: () async {
                          print(controller.songs.indexOf(e));
                          Global.audioHandler.playFromList(controller.songs,
                              startIndex: controller.songs.indexOf(e));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 8, bottom: 8),
                          child: Container(
                              width: 1.sw,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 1.sw - 84,
                                              child: Text("${e.title}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1))
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 1.sw - 84,
                                              child: Text(
                                                  "${e.artists!.map((x) => x.name).join("/")} - ${e.album!.name}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption))
                                        ],
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                      height: 0.45.sh < 450
                                                          ? 450
                                                          : 0.45.sh,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child:
                                                              BottomSongInfoSheet(
                                                                  e)))
                                                ],
                                              );
                                            });
                                      })
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              )),
                        ),
                      ))
                  .toList()),
        ));
  }
}
