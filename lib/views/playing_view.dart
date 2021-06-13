import 'dart:ui';

import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_util.dart';
import 'package:flutter_lyric/lyric_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koe/common/api.dart';
import 'package:koe/common/global.dart';
import 'package:koe/controller/SongInformationController.dart';
import 'package:koe/models/model.dart';
import 'package:simple_animations/simple_animations.dart';

class PlayingView extends StatefulWidget {
  PlayingView({Key? key}) : super(key: key);

  @override
  _PlayingViewState createState() => _PlayingViewState();
}

class _PlayingViewState extends State<PlayingView>
    with TickerProviderStateMixin {
  final SongInformationController controller = Get.find();

  _PlayingViewState() {
    Global.audioHandler.mediaItem.listen((value) async {
      try {
        if (value == null) return;

        getPaletteFromUrl(controller.artUri.value).then((palette) {
          color1.value =
              Color.fromRGBO(palette[0][0], palette[0][1], palette[0][2], .65);
          color2.value =
              Color.fromRGBO(palette[1][0], palette[1][1], palette[1][2], .65);
          color3.value =
              Color.fromRGBO(palette[2][0], palette[2][1], palette[2][2], .2);
        });

        var lyrics =
            await Api.fetchLyric(Song.fromJson(value.extras?["model"]).id!);
        songLyric.value = lyrics
                .where((element) => element.language == "source")
                .first
                .lyric ??
            "[00:00.00]暂无歌词";
        remarkLyric.value = lyrics
                .where((element) => element.language == "zh_CN")
                .first
                .lyric ??
            "[00:00.00]";
      } catch (e) {
        e.printError();
      }
    });
  }

  final temp = 0.0.obs;
  final color1 = Color(0xbbf44336).obs;
  final color2 = Color(0xa32196f3).obs;
  final color3 = Color(0x25e45a23).obs;

  var songLyric = "[00:00.00]获取歌词中".obs;
  var remarkLyric = "[00:00.00]...".obs;

  get horizontal => 0.8.sw > 1.sh;

  @override
  Widget build(BuildContext context) {
    final controlBar = Container(
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontal ? 0.35.sw : 0.05.sw),
                child: Obx(() => Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                size: 28,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(Icons.pause, size: 28),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(Icons.skip_next, size: 28),
                              onPressed: () {})
                        ],
                      ),
                      Slider(
                          activeColor: Color.fromRGBO(233, 233, 233, 0.8),
                          inactiveColor: Color.fromRGBO(233, 233, 233, 0.7),
                          value: controller.position *
                              1.0 /
                              controller.duration.value,
                          onChanged: (value) {})
                    ])))));

    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text("正在播放"),
            ),
            body: Obx(
              () => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color1.value, color2.value],
                      stops: [
                        0,
                        1,
                      ],
                    ),
                    backgroundBlendMode: BlendMode.screen,
                  ),
                  child: PlasmaRenderer(
                    type: PlasmaType.infinity,
                    particles: 10,
                    color: color3.value,
                    blur: 0.7,
                    size: 0.47,
                    speed: 1,
                    offset: 0,
                    blendMode: BlendMode.plus,
                    particleType: ParticleType.atlas,
                    variation1: 0,
                    variation2: 0,
                    variation3: 0,
                    rotation: 0.83,
                    child: Flex(direction: Axis.vertical, children: [
                      Expanded(
                        flex: 6,
                        child: Flex(
                            direction:
                                horizontal ? Axis.horizontal : Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 0,
                                  child: Align(
                                      alignment: horizontal
                                          ? Alignment.topLeft
                                          : Alignment.center,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: horizontal ? 30 : 20,
                                              vertical: horizontal ? 60 : 40),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(20)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image(
                                                width: 0.32.sh,
                                                height: 0.32.sh,
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    controller.artUri.value)),
                                            elevation: 16,
                                          )))),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: horizontal ? 20 : 60,
                                          vertical: horizontal ? 100 : 0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              controller.title.value,
                                              style: TextStyle(
                                                  fontSize: 24 + 5.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              controller.artist.value,
                                              style: TextStyle(
                                                  fontSize: 14 + 5.sp),
                                            ),
                                          ]))),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Obx(() => LyricWidget(
                                          size: Size(600, 750),
                                          vsync: this,
                                          lyricMaxWidth: 0.9.sw,
                                          lyrics: LyricUtil.formatLyric(
                                              songLyric.value),
                                          remarkLyrics: LyricUtil.formatLyric(
                                              remarkLyric.value),
                                          lyricGap: 5,
                                          remarkLyricGap: 15,
                                          lyricStyle: TextStyle(
                                              fontSize: 10 + 4.sp,
                                              color: Colors.white60),
                                          remarkStyle: TextStyle(
                                              fontSize: 6 + 4.sp,
                                              color: Colors.white60),
                                          currLyricStyle: TextStyle(
                                              fontSize: 18 + 4.sp,
                                              color: Colors.white),
                                          currRemarkLyricStyle: TextStyle(
                                              fontSize: 8 + 4.sp,
                                              color: Colors.white),
                                          currentProgress:
                                              controller.position.value / 1000,
                                        ))),
                              )
                            ]),
                      ),
                      Expanded(flex: 1, child: controlBar)
                    ]),
                  )),
            )));
  }
}
