import 'package:flutter/material.dart';
import 'package:mobile/model/profile_card.dart'; // UserProfile 모델을 정의한 파일을 임포트합니다.
import 'package:mobile/view/mate/mate_room_screen.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;

  ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return InkWell( // InkWell 추가
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MateRoomScreen(
              profileImageUrl: profile.profileImageUrl,
              mateName: profile.name,
              imageUrl: profile.imageUrl,
              audioUrl: 'audios/nature/defaultMainMusic2.mp3', // 예: 'https://example.com/music.mp3'
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profile.profileImageUrl),
          ),
          title: Text(profile.name),
          subtitle: Text(profile.currentActivity),
          trailing: Icon(
            profile.onlineStatus ? Icons.circle : Icons.circle_outlined,
            color: profile.onlineStatus ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
