import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // flutter 패키지 가져오는 코드
import 'package:mobile/const/colors.dart';
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
    if(backgroundProvider.isImage == false) {
      print("비디오 replay in building");
    }
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
        distance: 65,
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
                  transitionDuration: const Duration(milliseconds: 140),
                  reverseTransitionDuration: const Duration(milliseconds: 140),
                ),
              );
            },
            icon: const Icon(Icons.note_alt_rounded, size: 20, color: LIGHT_WHITE),
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
            icon: const Icon(Icons.library_music_rounded, size: 20, color: LIGHT_WHITE),
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
            icon: const Icon(CupertinoIcons.photo_fill, size: 20, color: LIGHT_WHITE),
          ),
        ],
      ),
    );
  }
}