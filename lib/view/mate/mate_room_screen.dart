import 'package:flutter/material.dart';
import 'package:mobile/view/myroom/background/backdrop_word/myroom_backdrop_word_screen.dart';
import 'package:mobile/view/myroom/widget/floating_todo.dart'; // MotivationalQuote 위젯을 import

class MateRoomScreen extends StatefulWidget {
  final String mateName;
  final String profileImageUrl;
  final String imageUrl;
  final String audioUrl;
  final bool isWordOpen;
  final bool isScheduleOpen;

  const MateRoomScreen({
    super.key,
    required this.mateName,
    required this.imageUrl,
    required this.audioUrl,
    required this.profileImageUrl,
    required this.isWordOpen,
    required this.isScheduleOpen,
  });

  @override
  _MateRoomScreenState createState() => _MateRoomScreenState();
}

class _MateRoomScreenState extends State<MateRoomScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mateName}의 방'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // isWordOpen이 true일 때 MotivationalQuote 표시
          if (widget.isWordOpen)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: MotivationalQuote(),
            ),

          // isScheduleOpen이 true일 때 FloatingTodo 표시
          if (widget.isScheduleOpen)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingTodo(),
            ),
        ],
      ),
    );
  }
}