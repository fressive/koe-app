import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:koe/common/api.dart';
import 'package:koe/models/model.dart';

import 'package:koe/widgets/playlist.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class CloudMusicView extends StatefulWidget {
  const CloudMusicView({Key? key}) : super(key: key);

  @override
  State<CloudMusicView> createState() => _CloudMusicViewState();
}

class _CloudMusicViewState extends State<CloudMusicView> {
  final PlaylistController controller = Get.put(PlaylistController());

  Future<List<Song>> fetchSongs() async {
    var rep = await Api.getFullSongList();

    controller.updateSongs(rep);
    return rep;
  }

  @override
  Widget build(BuildContext context) {
    fetchSongs();

    return Scaffold(
        appBar: AppBar(
          title: Text("云端音乐"),
        ),
        body: EasyRefresh(
          child: Column(children: [
            SimpleAutocompleteFormField<Artist>(
              onSearch: (search) async => await Api.searchArtists(search),
              itemBuilder: (context, item) {
                //print(item);
                return Text(item!.name!);
              },
            ),
            PlaylistWidget()
          ]),
          onRefresh: () async => await fetchSongs(),
          onLoad: () async => await fetchSongs(),
        ));
  }
}
