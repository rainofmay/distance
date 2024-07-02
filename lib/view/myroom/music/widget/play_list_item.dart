import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/music/music_detail_screen.dart';

class PlayListItem extends StatefulWidget {
  final String thumbnailUrl;
  final String title;
  final String instrument;
  final Color textColor;
  final int numberOfsongs;
  final void Function()? onTap;
  const PlayListItem({super.key, required this.thumbnailUrl, required this.title, required this.instrument, required this.numberOfsongs, this.onTap, required this.textColor});

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MusicDetailScreen()),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.thumbnailUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 15, color: widget.textColor)),
              const SizedBox(height: 5),
              Text('${widget.instrument}  |  ${widget.numberOfsongs}곡',
                  style: TextStyle(fontSize: 11, color: widget.textColor)),
            ],
          )
        ],
      ),
    );
  }
}
