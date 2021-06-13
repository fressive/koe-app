import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:koe/common/global.dart';
import 'package:koe/common/player.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koe/controller/SongInformationController.dart';

class BottomPlayerBarWidget extends StatelessWidget {
  final SongInformationController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 0.06.sh < 55 ? 55 : 0.06.sh,
                child: Row(
                  children: [
                    SizedBox(
                      height: 55,
                      width: 100,
                    ),
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${c.title}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1),
                          Text("${c.artist}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption)
                        ]),
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: c.playing.value
                                ? IconButton(
                                    icon: Icon(
                                      Icons.pause_circle_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                    onPressed: () =>
                                        {Global.audioHandler.pause()},
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.play_circle_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                    onPressed: () =>
                                        {Global.audioHandler.play()},
                                  )),
                        IconButton(
                            onPressed: () async {},
                            icon: Icon(
                              Icons.playlist_play_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            )),
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              LinearProgressIndicator(
                value: c.position.value / c.duration.value,
                minHeight: 2,
              )
            ])));
  }
}
