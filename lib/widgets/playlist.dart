import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:koe/common/player.dart';

import 'package:koe/models/song.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({Key key, this.songs}) : super(key: key);

  final List<Song> songs;

  @override
  _PlaylistWidgetState createState() => new _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    widget.songs.forEach((e) {
      list.add(InkWell(
        onTap: () async {
          Player.play(e);
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 4.0, top: 6, bottom: 6),
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
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.subtitle1))
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 1.sw - 84,
                              child: Text("${e.artists.join("/")}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.caption))
                        ],
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  IconButton(icon: Icon(Icons.more_vert), onPressed: null)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )),
        ),
      ));
    });

    return SingleChildScrollView(
      child: Column(
        children: list,
      ),
    );
  }
}
