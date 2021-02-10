import 'package:flutter/material.dart';
import 'package:koe/common/api.dart';
import 'package:koe/models/song.dart';
import 'package:koe/widgets/bottom_player_bar.dart';

import 'package:koe/widgets/playlist.dart';

class CloudMusicView extends StatefulWidget {
  const CloudMusicView({Key key}) : super(key: key);

  @override
  State<CloudMusicView> createState() => _CloudMusicViewState();
}

class _CloudMusicViewState extends State<CloudMusicView> {
  Future<List<Song>> fetchSongs() async {
    var rep = await Api.getFullSongList();
    return rep;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("云端音乐"),
      ),
      body: FutureBuilder(
          future: fetchSongs(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return PlaylistWidget(songs: snapshot.data as List<Song>);
              }
            }
            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }),
    );
  }
}
