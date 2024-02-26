import 'package:flutter/material.dart'; // flutter 패키지 가져오는 코드
import 'package:mobile/util/background_setting_provider.dart';
import 'package:mobile/widgets/action_buttons.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'package:mobile/pages/myroom_music.dart';
import 'package:mobile/pages/myroom_schedule.dart';
import 'package:provider/provider.dart';
import 'package:mobile/widgets/floating_todo.dart';
import 'package:mobile/pages/myroom_background.dart';
import 'package:video_player/video_player.dart';
import '../util/background_provider.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final backgroundProvider = Provider.of<BackgroundProvider>(context, listen: false);
    if (!backgroundProvider.isImage) {
      _controller = VideoPlayerController.networkUrl(
        'https://firebasestorage.googleapis.com/v0/b/cled-180e0.appspot.com/o/video%2Fsea(1080p).mp4?alt=media&token=93b8b695-4f52-4f34-a10c-0c78f135d4d4' as Uri,
      )..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    final backgroundSettingProvider =
    Provider.of<BackgroundSettingProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          if (backgroundProvider.isImage)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(backgroundProvider.selectedImageURL),
                ),
              ),
            )
          else if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          //할 일들
          Container(
            child: backgroundSettingProvider.simpleWindowEnable
                ? FloatingTodo()
                : null,
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 60,
        sub: [
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Schedule(),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 140),
                  reverseTransitionDuration: Duration(milliseconds: 140),
                ),
              );
            },
            icon: Icon(Icons.edit_calendar_sharp, size: 20, color: Colors.white70),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return MusicSetting();
                },
              );
            },
            icon: Icon(Icons.music_note_outlined, size: 20, color: Colors.white70),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return BackgroundSetting();
                },
              );
            },
            icon: Icon(Icons.photo_camera_back, size: 20, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
