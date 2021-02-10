
import 'package:event_bus/event_bus.dart';
import 'package:koe/models/song.dart';

EventBus eventBus = EventBus();

class SongChangedEventFn {
  final Song newSong;

  SongChangedEventFn({
    this.newSong
  });
}

class StartPlayingEventFn {}

class StopPlayingEventFn {}

