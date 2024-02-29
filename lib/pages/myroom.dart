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
  const MyRoom({Key? key}) : super(key: key);

  @override
  _MyRoomState createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  final videoUrl = Uri.parse('https://firebasestorage.googleapis.com/v0/b/cled-180e0.appspot.com/o/video%2Fsea(1080p).mp4?alt=media&token=93b8b695-4f52-4f34-a10c-0c78f135d4d4');
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
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
            //영상으로 선택되어있을 땐 이걸 튼다.
          else if (!backgroundProvider.isImage && backgroundProvider.videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: backgroundProvider.videoController.value.size.width,
                  height: backgroundProvider.videoController.value.size.height,
                  child: VideoPlayer(backgroundProvider.videoController),
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

