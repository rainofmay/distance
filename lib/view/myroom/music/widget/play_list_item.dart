import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/music/music_detail_screen.dart';

class PlayListItem extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String info;
  final Color textColor;
  final int numberOfSongs;
  final void Function()? onTap;
  const PlayListItem({super.key, required this.thumbnailUrl, required this.title, required this.info, required this.numberOfSongs, this.onTap, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              thumbnailUrl,
              fit: BoxFit.cover,
              width: 70,
              height: 70,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 15, color: textColor)),
              const SizedBox(height: 16),
              Text('$info  |  $numberOfSongs곡',
                  style: TextStyle(fontSize: 11, color: textColor)),
            ],
          )
        ],
      ),
    );
  }
}
