import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'music_view_model.dart';

class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final MusicViewModel _viewModel;
  final AudioPlayer _player;

  AudioPlayerHandler(this._viewModel, this._player) {
    _player.onPlayerStateChanged.listen(_broadcastState);
    _player.onDurationChanged.listen(_broadcastDuration);
    _player.onPositionChanged.listen(_broadcastPosition);
    _player.onPlayerComplete.listen((_) => _handlePlaybackCompletion());

    // 초기 상태 설정
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(playing: true));
    await _player.resume();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(playing: false));
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    await _player.stop();
  }

  @override
  Future<void> skipToNext() => _viewModel.nextTrack();

  @override
  Future<void> skipToPrevious() => _viewModel.previousTrack();

  void _broadcastState(PlayerState state) {
    playbackState.add(playbackState.value.copyWith(
      playing: state == PlayerState.playing,
      processingState: const {
        PlayerState.stopped: AudioProcessingState.idle,
        PlayerState.playing: AudioProcessingState.ready,
        PlayerState.paused: AudioProcessingState.ready,
        PlayerState.completed: AudioProcessingState.completed,
      }[state]!,
    ));
  }

  void _broadcastDuration(Duration? duration) {
    if (duration != null) {
      mediaItem.add(mediaItem.value?.copyWith(duration: duration));
    }
  }

  void _broadcastPosition(Duration position) {
    // playbackState.add(playbackState.value.copyWith(position: position));
  }

  void _handlePlaybackCompletion() {
    _viewModel.nextTrack();
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    // 먼저 mediaItem을 업데이트합니다.
    mediaItem.add(item);

    try {
      await _player.play(DeviceFileSource(item.id));
      playbackState.add(playbackState.value.copyWith(
        playing: true,
        processingState: AudioProcessingState.ready,
      ));
      if (kDebugMode) {
        print('Playing media item: ${item.title}');
        print('Media item details: $item');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing media item: $e');
      }
    }
  }

  // void updateMediaItem(MediaItem item) {
  //   mediaItem.add(item);
  //   if (kDebugMode) {
  //     print('Updated media item: ${item}');
  //   }
  // }
}