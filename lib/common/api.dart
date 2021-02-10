import 'dart:typed_data';

import 'package:koe/common/global.dart';
import 'package:koe/models/api_response.dart';

import 'package:dio/dio.dart' as dio;
import 'package:koe/models/song.dart';

class Api {
  static String get API_V1_ENDPOINT => '${AppConfig.serverUrl.value}/api/v1';
  static String get API_GET_BACKEND_VERSION => '$API_V1_ENDPOINT/version';
  static String get API_GET_SONG_LIST => '$API_V1_ENDPOINT/songs';
  static String get API_GET_FILE => '$API_V1_ENDPOINT/file/{file_id}';

  static final client = dio.Dio();

  static Future<ApiResponse<dynamic>> getBackendVersion() async {
    var rep = await client.get(API_GET_BACKEND_VERSION);

    return ApiResponse<dynamic>.fromJson(rep.data);
  }

  static Future<List<Song>> getSongList({int page = 1, int limit = 100}) async {
    try {
      var rep = await client.get(API_GET_SONG_LIST,
          queryParameters: {"page": page, "limit": limit});

      // print(rep.data["data"].runtimeType);
      var a = (rep.data["data"] as List<dynamic>);
      var r = a.map((e) {
        //print(e);
        return Song.fromJson(e);
      }).toList();

      return r;
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Song>> getFullSongList() async {
    int page = 1;
    bool notEmpty = true;

    List<Song> songs = <Song>[];

    do {
      var rep = await getSongList(page: page++);
      songs.addAll(rep);

      notEmpty = rep.isNotEmpty;
    } while (notEmpty);

    return songs;
  }

  static String getFileLink(fileId) {
    return Api.API_GET_FILE.replaceAll("{file_id}", fileId.toString());
  }

  static Future<Uint8List> getFileData(fileId) async {
    return ((await client.get(getFileLink(fileId))).data as Uint8List);
  }
}
