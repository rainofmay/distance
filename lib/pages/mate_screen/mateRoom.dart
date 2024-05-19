import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MateRoom extends StatefulWidget {
  final String mateName;
  final String profileImageUrl;
  final String imageUrl;
  final String audioUrl;

  const MateRoom({super.key, required this.mateName,required this.imageUrl, required this.audioUrl, required this.profileImageUrl, });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<MateRoom> {
  late AudioPlayer _audioPlayer;
  bool isLoading = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource(widget.audioUrl));
    //fetching으로 가져오기
    isLoading = false;
    _isPlaying = true;
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _togglePlay,
              child: Text(_isPlaying ? '음악 정지' : '음악 재생'),
            ),
            Image.network(widget.imageUrl),
          ],
        ),
      ),
    );
  }
}
