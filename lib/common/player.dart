import 'package:audio_service/audio_service.dart';

import 'package:just_audio/just_audio.dart';
import 'package:koe/models/model.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';
import 'global.dart';

class MediaState {
  final MediaItem mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class DefaultAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final _player = AudioPlayer();
  final List<MediaItem> playlist = [];

  static late int index;

  get positionStream => _player.positionStream;
  get durationStream => _player.durationStream;
  get playbackStateStream => _player.playerStateStream;

  DefaultAudioHandler() {
    _player.playbackEventStream.listen((event) {
      if (playbackState.value == null) return;

      playbackState.add(playbackState.value!.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: [0, 1, 3],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });
  }

  @override
  play() async {
    _player.play();
  }

  playFromMediaItem(MediaItem item) async {
    mediaItem.add(item);

    playbackState.add(playbackState.valueWrapper!.value.copyWith(
      playing: _player.playing,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    ));

    AudioService.androidForceEnableMediaButtons();

    await _player.setUrl(Api.API_GET_FILE
        .replaceAll("{file_id}", item.extras!["model"].audioFiles[0].id!));
    await play();
  }

  playSong(Song song) async {
    await playFromMediaItem(MediaItem(
        id: song.id!,
        album: song.album!.name!,
        title: song.title!,
        artist: song.artists!.map((e) => e.name).join("/"),
        artUri: Uri.parse(song.coverFiles?.length != 0
            ? Api.API_GET_FILE.replaceAll("{file_id}", song.coverFiles![0].id!)
            : "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3761843179,3646757056&fm=26&gp=0.jpg"),
        extras: {"model": song}));
  }

  playFromList(List<Song> playlist, {int startIndex = 0}) async {
    this.playlist.clear();
    index = startIndex;

    var mapped = playlist
        .map((song) => MediaItem(
            id: song.id!,
            album: song.album!.name!,
            title: song.title!,
            artist: song.artists!.map((e) => e.name).join("/"),
            artUri: Uri.parse(song.coverFiles?.length != 0
                ? Api.API_GET_FILE
                    .replaceAll("{file_id}", song.coverFiles![0].id!)
                : "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3761843179,3646757056&fm=26&gp=0.jpg"),
            extras: {"model": song}))
        .toList();

    playbackState.add(playbackState.valueWrapper!.value.copyWith(
      playing: _player.playing,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    ));
    this.playlist.addAll(mapped);

    this.addQueueItems(this.playlist);
    this.updateQueue(this.playlist);
    this.setRepeatMode(AudioServiceRepeatMode.all);

    await this.playFromMediaItem(mapped[startIndex]);
  }

  @override
  skipToPrevious() async {
    if (--index < 0) index = playlist.length - 1;

    await stop();
    await playFromMediaItem(playlist[index]);
  }

  @override
  skipToNext() async {
    if (++index > playlist.length - 1) index = 0;

    await stop();
    await playFromMediaItem(playlist[index]);
  }

  @override
  pause() async {
    _player.pause();
  }

  @override
  seek(Duration position) => _player.seek(position);

  @override
  stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  customAction(String name, Map<String, dynamic>? arguments) async {
    switch (name) {
      case 'setVolume':
        _player.setVolume(arguments?['volume']);
        break;
      case 'saveBookmark':
        // app-specific code
        break;
    }
  }
}

class Player {
  static Song? currentSong;

  static void play(Song song) async {
    Global.audioHandler.play();
  }

  static void pause() async {
    Global.audioHandler.pause();
  }

  static void resume() async {
    Global.audioHandler.play();
  }
}
