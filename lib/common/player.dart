
import 'package:just_audio/just_audio.dart';
import 'package:koe/common/eventBus.dart';
import 'package:koe/models/song.dart';

import 'api.dart';

class Player {
  static final player = AudioPlayer();

  static bool get isPlaying => player.playing;

  static Song currentSong;

  static void play(Song song) async {

    var url = Api.API_GET_FILE.replaceAll("{file_id}", song.filesId[0].toString());

    print(url);
    await player.setUrl(url);
    player.play();
    currentSong = song;
    eventBus.fire(SongChangedEventFn(newSong: song));
    //(song.filesId[0];
  }

  static void pause() async {
    eventBus.fire(StopPlayingEventFn());

    player.pause();
  }

  static void resume() async {
    eventBus.fire(StartPlayingEventFn());
    player.play();
  }
}

