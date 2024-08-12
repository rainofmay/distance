// import 'package:audio_service/audio_service.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:get/get.dart';
// import 'package:mobile/view_model/myroom/music/sound_view_model.dart';
//
// import 'music_view_model.dart';
//
// class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
//   final MusicViewModel _viewModel;
//   final AudioPlayer _player;
//   AudioPlayerHandler(this._viewModel, this._player) {
//     _player.onPlayerStateChanged.listen(_broadcastState);
//     _player.onDurationChanged.listen(_broadcastDuration);
//     _player.onPositionChanged.listen(_broadcastPosition);
//     _player.onPlayerComplete.listen((_) => _handlePlaybackCompletion());
//
//     // 초기 상태 설정
//     playbackState.add(PlaybackState(
//       controls: [
//         MediaControl.skipToPrevious,
//         MediaControl.play,
//         MediaControl.pause,
//         MediaControl.skipToNext,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: AudioProcessingState.idle,
//       playing: false,
//     ));
//
//     initializeMediaItem();
// }
//   Future<void> initializeMediaItem() async {
//     final currentItem = _viewModel.currentMediaItem;
//     if (currentItem != null) {
//       mediaItem.add(currentItem);
//     } else {
//       mediaItem.add(MediaItem(
//         id: 'initial',
//         album: 'Unknown album',
//         title: 'Unknown title',
//         artist: 'Unknown artist',
//         duration: Duration.zero,
//       ));
//     }
//   }
//
//   @override
//   Future<void> play() async {
//     await addMediaItem(_viewModel.currentMediaItem!);
//     playbackState.add(playbackState.value.copyWith(playing: true));
//     await _player.resume();
//   }
//
//   @override
//   Future<void> pause() async {
//     await addMediaItem(_viewModel.currentMediaItem!);
//     final soundViewModel = Get.find<SoundViewModel>();
//     playbackState.add(playbackState.value.copyWith(playing: false));
//     await _player.pause();
//     soundViewModel.musicPauseAll();
//   }
//
//   @override
//   Future<void> seek(Duration position) => _player.seek(position);
//
//   @override
//   Future<void> stop() async {
//     playbackState.add(playbackState.value.copyWith(
//       playing: false,
//       processingState: AudioProcessingState.idle,
//     ));
//     await _player.stop();
//   }
//
//   @override
//   Future<void> skipToNext() async{
//     await _viewModel.nextTrack();
//     await addMediaItem(_viewModel.currentMediaItem!);
//   }
//
//   @override
//   Future<void> skipToPrevious() async{
//     await _viewModel.previousTrack();
//     await addMediaItem(_viewModel.currentMediaItem!);
//   }
//   void _broadcastState(PlayerState state) {
//     playbackState.add(playbackState.value.copyWith(
//       playing: state == PlayerState.playing,
//       processingState: const {
//         PlayerState.stopped: AudioProcessingState.idle,
//         PlayerState.playing: AudioProcessingState.ready,
//         PlayerState.paused: AudioProcessingState.ready,
//         PlayerState.completed: AudioProcessingState.completed,
//       }[state]!,
//     ));
//   }
//
//   void _broadcastDuration(Duration? duration) {
//     if (duration != null) {
//       mediaItem.add(mediaItem.value?.copyWith(duration: duration));
//     }
//   }
//
//   void _broadcastPosition(Duration position) {
//     // playbackState.add(playbackState.value.copyWith(position: position));
//   }
//
//   void _handlePlaybackCompletion() {
//     _viewModel.nextTrack();
//   }
//
//   Future<void> addMediaItem(MediaItem item) async {
//     // 먼저 mediaItem을 업데이트합니다.
//     mediaItem.add(item);
//   }
//
//
// }