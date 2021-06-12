import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:koe/common/global.dart';

import 'package:dio/dio.dart' as dio;
import 'package:graphql/client.dart';
import 'package:koe/models/model.dart';
import 'package:http_parser/http_parser.dart';

class Api {
  // ignore: non_constant_identifier_names
  static String get API_V1_ENDPOINT => '${AppConfig.serverUrl.value}/api/v1';

  // ignore: non_constant_identifier_names
  static String get API_GET_FILE => '$API_V1_ENDPOINT/file/id/{file_id}';

  // ignore: non_constant_identifier_names
  static String get API_UPLOAD_FILE => '$API_V1_ENDPOINT/file/upload';

  // ignore: non_constant_identifier_names
  static String get API_GRAPHQL => '${AppConfig.serverUrl.value}/api/graphql';

  static final _link = HttpLink(API_GRAPHQL);

  static Policies policies = Policies(
    fetch: FetchPolicy.networkOnly,
  );

  static final client = GraphQLClient(
    cache: GraphQLCache(),
    link: _link,
    defaultPolicies: DefaultPolicies(
      watchQuery: policies,
      query: policies,
      mutate: policies,
    ),
  );

  static final httpClient = dio.Dio();

  static Future<Map<String, dynamic>> performRequest(options) async {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      throw result.exception!;
    }

    return result.data!;
  }

  /// Get backend version
  /// [return] version code
  static Future<String> getBackendVersion() async {
    var query = r'''
      query {
        version
      }
    ''';

    QueryOptions options = QueryOptions(document: gql(query));
    return (await performRequest(options))["version"];
  }

  /// Get song list
  /// [return] song list
  static Future<List<Song>> getSongList({int page = 0, int limit = 100}) async {
    try {
      var query = '''
        query {
          songs(page: $page, limit: $limit) {
            id,
            album {
              id,
              name
            },
            title,
            lyrics {
              id
            },
            aliases,
            artists {
              id,
              name
            },
            updateTime,
            audioFiles {
              id
            },
            coverFiles {
              id
            }
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return List<Song>.from((await performRequest(options))["songs"]
          .map((x) => Song.fromJson(x)));
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Artist>> searchArtists(String keyword) async {
    try {
      var query = '''
        query {
          artists(keywords: ["$keyword"]) {
            aliases
            country
            coverFiles {
              id
            }
            id
            name
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return List<Artist>.from((await performRequest(options))["artists"]
          .map((x) => Artist.fromJson(x)));
    } catch (e) {
      rethrow;
    }
  }

  static Future<Artist> createArtist(Artist artist) async {
    try {
      var query = '''
        mutation {
          createArtist(name: "${artist.name}") {
            ok,
            artist {
              id
            }
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return Artist.fromJson(
          (await performRequest(options))["createArtist"]["artist"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Album>> searchAlbums(String keyword) async {
    try {
      var query = '''
        query {
          albums (keyword: "$keyword") {
            name,
            id,
            artists {
              id,
              name
            },
            coverFiles {
              id,
              md5
            },
            releasedDate,
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return List<Album>.from((await performRequest(options))["albums"]
          .map((x) => Album.fromJson(x)));
    } catch (e) {
      rethrow;
    }
  }

  static Future<FileElement> fetchFile(String fileId) async {
    try {
      var query = '''
        {
          files(fileId: "$fileId") {
            fileType
            id
            provider
            md5
            metadata
            updateTime
            extension
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return FileElement.fromJson(
          (await performRequest(options))["files"].first);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Lyric>> fetchLyric(String songId) async {
    try {
      var query = '''
        {
          lyrics(songId: "$songId") {
            id
            md5
            type
            source
            language
            lyric
          }
        }
      ''';

      QueryOptions options = QueryOptions(document: gql(query));

      return List<Lyric>.from((await performRequest(options))["lyrics"]
          .map((x) => Lyric.fromJson(x)));
    } catch (e) {
      rethrow;
    }
  }

  static Future<Album> createAlbum(Album album) async {
    try {
      var query = r'''
        mutation ($artistsId: [String]!, $name: String!) {
          createAlbum (artistsId: $artistsId, name: $name) {
            ok,
            album {
              id
            }
          }
        }
      ''';

      QueryOptions options = QueryOptions(
          document: gql(query),
          variables: <String, dynamic>{
            'name': album.name,
            'artistsId': album.artists!.map((e) => e.id).toList()
          });

      return Album.fromJson(
          (await performRequest(options))["createAlbum"]["album"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Song> createSong(Song song) async {
    try {
      var query = r"""
        mutation ($albumId: String!, $aliases: [String], $artistsId: [String]!, $audioFiles: [String], $title: String!) {
          createSong (
            albumId: $albumId, 
            aliases: $aliases, 
            artistsId: $artistsId, 
            audioFiles: $audioFiles, 
            title: $title
          ) {
            song {
              id
            }
          }
        }
      """;

      QueryOptions options =
          QueryOptions(document: gql(query), variables: <String, dynamic>{
        'albumId': song.album?.id,
        'aliases': song.aliases,
        'artistsId': song.artists?.map((e) => e.id).toList(),
        'audioFiles': song.audioFiles?.map((e) => e.id).toList(),
        'title': song.title
      });

      return Song.fromJson(
          (await performRequest(options))["createSong"]["song"]);
    } catch (e) {
      throw e;
    }
  }

  static Future<Song> createSongFromMeta(
      List<String> artists, String album, String title, String fileId) async {
    var query = r'''
      query ($album: [String], $artists: [String]) {
        albums (keywords: $album, regexp: "^{}$") {
          id
        }
        
        artists (keywords: $artists, regexp: "^{}$") {
          id,
          name
        }
      }
    ''';

    QueryOptions options =
        QueryOptions(document: gql(query), variables: <String, dynamic>{
      'album': [album],
      'artists': artists
    });
    var result = await performRequest(options);

    var artistRes =
        List<Artist>.from(result["artists"].map((x) => Artist.fromJson(x)));

    var albumRes =
        List<Album>.from(result["albums"].map((x) => Album.fromJson(x)));

    if (artistRes.length != artists.length) {
      for (var i in artists) {
        if (!artistRes.map((e) => e.name).contains(i)) {
          artistRes.add(await createArtist(Artist(name: i)));
        }
      }
    }

    if (albumRes.isEmpty) {
      albumRes.add(await createAlbum(Album(name: album, artists: artistRes)));
    }

    var songRes = await createSong(Song(
        artists: artistRes,
        album: albumRes[0],
        title: title,
        audioFiles: [FileElement(id: fileId)]));

    return songRes;
  }

  static Future<List<Song>> getFullSongList() async {
    int page = 0;
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
    return ((await httpClient.get(getFileLink(fileId))).data as Uint8List);
  }

  static Future<dynamic> uploadFile(data, filename, mediatype) async {
    var formData = FormData.fromMap({
      "files": [
        MultipartFile.fromBytes(data,
            filename: filename, contentType: MediaType.parse(mediatype))
      ]
    });

    return (await httpClient.post(API_UPLOAD_FILE, data: formData)).data;
  }
}
