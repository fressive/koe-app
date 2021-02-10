import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koe/common/eventBus.dart';
import 'package:koe/common/player.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomPlayerBarWidget extends StatefulWidget {
  const BottomPlayerBarWidget({Key key}) : super(key: key);

  @override
  _BottomPlayerBarWidgetState createState() =>
      new _BottomPlayerBarWidgetState();
}

class _BottomPlayerBarWidgetState extends State<BottomPlayerBarWidget> {
  String _title = "歌曲";
  String _artist = "艺术家";

  StreamSubscription _songChangedEvent;
  StreamSubscription _startPlayingEvent;
  StreamSubscription _stopPlayingEvent;

  bool playing = Player.isPlaying;

  @override
  dispose() {
    super.dispose();
    _songChangedEvent.cancel();
    _startPlayingEvent.cancel();
    _stopPlayingEvent.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _songChangedEvent = eventBus.on<SongChangedEventFn>().listen((event) {
      setState(() {
        _title = event.newSong.title;
        _artist = event.newSong.artists.join("/");
        playing = true;
      });
    });

    _startPlayingEvent = eventBus.on<StartPlayingEventFn>().listen((event) {
      setState(() {
        playing = true;
      });
    });

    _stopPlayingEvent = eventBus.on<StopPlayingEventFn>().listen((event) {
      setState(() {
        playing = false;
      });
    });

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        children: [
          SizedBox(),
          Padding(
              padding: const EdgeInsets.only(left: 90, top: 10, bottom: 5),
              child: Container(
                width: 1.sw - 190,
                height: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Expanded(
                          child: Text(_title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1)),
                    ),
                    Container(
                      child: Expanded(
                          child: Text(_artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption)),
                    ),
                  ],
                ),
              )),
          Expanded(child: SizedBox()),
          Row(
            children: [
              Container(
                width: 40,
                child: IconButton(
                    onPressed: () =>
                        {if (playing) Player.pause() else Player.resume()},
                    icon: playing
                        ? Icon(Icons.pause_circle_outline,
                            color: Theme.of(context).primaryColor)
                        : Icon(Icons.play_circle_outline,
                            color: Theme.of(context).primaryColor),
                    iconSize: 38),
              ),
              Container(
                  child: IconButton(
                icon: Icon(Icons.playlist_play,
                    color: Theme.of(context).primaryColor),
                iconSize: 32,
              )),
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}
