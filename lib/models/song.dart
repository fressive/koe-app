class Song {
  String title;
  String titleRomanised;
  List<int> albumId;
  List<int> artistsId;
  List<int> tagsId;
  int coverFileId;
  List<int> filesId;
  int id;
  double updateTime;
  List<String> artists;

  Song(
      {this.title,
        this.titleRomanised,
        this.albumId,
        this.artistsId,
        this.tagsId,
        this.coverFileId,
        this.filesId,
        this.id,
        this.updateTime,
        this.artists});

  Song.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    titleRomanised = json['title_romanised'];
    albumId = json['album_id'];
    artistsId = json['artists_id']?.cast<int>();
    tagsId = json['tags_id']?.cast<int>();
    coverFileId = json['cover_file_id'];
    filesId = json['files_id']?.cast<int>();
    id = json['id'];
    updateTime = json['update_time'];
    artists = json['artists']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['title_romanised'] = this.titleRomanised;
    data['album_id'] = this.albumId;
    data['artists_id'] = this.artistsId;
    data['tags_id'] = this.tagsId;
    data['cover_file_id'] = this.coverFileId;
    data['files_id'] = this.filesId;
    data['id'] = this.id;
    data['update_time'] = this.updateTime;
    data['artists'] = this.artists;
    return data;
  }
}