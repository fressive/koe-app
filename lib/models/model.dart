// To parse this JSON data, do
//
//     final song = songFromJson(jsonString);

import 'dart:convert';

class Song {
  Song({
    this.id,
    this.album,
    this.title,
    this.lyrics,
    this.aliases,
    this.artists,
    this.updateTime,
    this.audioFiles,
    this.coverFiles,
  });

  String? id;
  Album? album;
  String? title;
  List<dynamic>? lyrics;
  List<dynamic>? aliases;
  List<Artist>? artists;
  DateTime? updateTime;
  List<FileElement>? audioFiles;
  List<FileElement>? coverFiles;

  factory Song.fromRawJson(String str) => Song.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"] == null ? null : json["id"],
        album: json["album"] == null ? null : Album.fromJson(json["album"]),
        title: json["title"] == null ? null : json["title"],
        lyrics: json["lyrics"] == null
            ? null
            : List<dynamic>.from(json["lyrics"].map((x) => x)),
        aliases: json["aliases"] == null
            ? null
            : List<dynamic>.from(json["aliases"].map((x) => x)),
        artists: json["artists"] == null
            ? null
            : List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        audioFiles: json["audioFiles"] == null
            ? null
            : List<FileElement>.from(
                json["audioFiles"].map((x) => FileElement.fromJson(x))),
        coverFiles: json["coverFiles"] == null
            ? null
            : List<FileElement>.from(
                json["coverFiles"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "album": album == null ? null : album?.toJson(),
        "title": title == null ? null : title,
        "lyrics":
            lyrics == null ? null : List<dynamic>.from(lyrics!.map((x) => x)),
        "aliases":
            aliases == null ? null : List<dynamic>.from(aliases!.map((x) => x)),
        "artists": artists == null
            ? null
            : List<dynamic>.from(artists!.map((x) => x.toJson())),
        "updateTime": updateTime == null ? null : updateTime?.toIso8601String(),
        "audioFiles": audioFiles == null
            ? null
            : List<dynamic>.from(audioFiles!.map((x) => x.toJson())),
        "coverFiles": coverFiles == null
            ? null
            : List<dynamic>.from(coverFiles!.map((x) => x.toJson())),
      };
}

class Album {
  Album({
    this.id,
    this.name,
    this.artists,
    this.coverFiles,
    this.releasedDate,
  });

  String? id;
  String? name;
  List<Artist>? artists;
  List<dynamic>? coverFiles;
  DateTime? releasedDate;

  factory Album.fromRawJson(String str) => Album.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        artists: json["artists"] == null
            ? null
            : List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        coverFiles: json["coverFiles"] == null
            ? null
            : List<dynamic>.from(json["coverFiles"].map((x) => x)),
        releasedDate: json["releasedDate"] == null
            ? null
            : DateTime.parse(json["releasedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "artists": artists == null
            ? null
            : List<dynamic>.from(artists!.map((x) => x.toJson())),
        "coverFiles": coverFiles == null
            ? null
            : List<dynamic>.from(coverFiles!.map((x) => x)),
        "releasedDate": releasedDate == null
            ? null
            : "${releasedDate?.year.toString().padLeft(4, '0')}-${releasedDate?.month.toString().padLeft(2, '0')}-${releasedDate?.day.toString().padLeft(2, '0')}",
      };
}

class Artist {
  Artist({
    this.id,
    this.name,
    this.aliases,
    this.country,
    this.coverFiles,
  });

  String? id;
  String? name;
  List<String>? aliases;
  String? country;
  List<FileElement>? coverFiles;

  factory Artist.fromRawJson(String str) => Artist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        aliases: json["aliases"] == null
            ? null
            : List<String>.from(json["aliases"].map((x) => x)),
        country: json["country"] == null ? null : json["country"],
        coverFiles: json["coverFiles"] == null
            ? null
            : List<FileElement>.from(json["coverFiles"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "aliases":
            aliases == null ? null : List<dynamic>.from(aliases!.map((x) => x)),
        "country": country == null ? null : country,
        "coverFiles": coverFiles == null
            ? null
            : List<dynamic>.from(coverFiles!.map((x) => x)),
      };
}

class FileElement {
  FileElement({
    this.id,
    this.md5,
    this.fileType,
    this.metadata,
    this.provider,
    this.extension,
    this.updateTime,
    this.contentType,
  });

  String? id;
  String? md5;
  String? fileType;
  String? metadata;
  String? provider;
  String? extension;
  DateTime? updateTime;
  String? contentType;

  factory FileElement.fromRawJson(String str) =>
      FileElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"] == null ? null : json["id"],
        md5: json["md5"] == null ? null : json["md5"],
        fileType: json["fileType"] == null ? null : json["fileType"],
        metadata: json["metadata"] == null ? null : json["metadata"],
        provider: json["provider"] == null ? null : json["provider"],
        extension: json["extension"] == null ? null : json["extension"],
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        contentType: json["contentType"] == null ? null : json["contentType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "md5": md5 == null ? null : md5,
        "fileType": fileType == null ? null : fileType,
        "metadata": metadata == null ? null : metadata,
        "provider": provider == null ? null : provider,
        "extension": extension == null ? null : extension,
        "updateTime": updateTime == null ? null : updateTime?.toIso8601String(),
        "contentType": contentType == null ? null : contentType,
      };
}

class Lyric {
  Lyric({
    this.id,
    this.song,
    this.md5,
    this.type,
    this.source,
    this.language,
    this.lyric,
  });

  String? id;
  Song? song;
  String? md5;
  String? type;
  String? source;
  String? language;
  String? lyric;

  factory Lyric.fromRawJson(String str) => Lyric.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lyric.fromJson(Map<String, dynamic> json) => Lyric(
        id: json["id"] == null ? null : json["id"],
        song: json["song"] == null ? null : Song.fromJson(json["song"]),
        md5: json["md5"] == null ? null : json["md5"],
        type: json["type"] == null ? null : json["type"],
        source: json["source"] == null ? null : json["source"],
        language: json["language"] == null ? null : json["language"],
        lyric: json["lyric"] == null ? null : json["lyric"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "song": song == null ? null : song?.toJson(),
        "md5": md5 == null ? null : md5,
        "type": type == null ? null : type,
        "source": source == null ? null : source,
        "language": language == null ? null : language,
        "lyric": lyric == null ? null : lyric,
      };
}
