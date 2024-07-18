import 'package:flutter/material.dart';


class MateRoomScreen extends StatefulWidget {
  final String mateName;
  final String profileImageUrl;
  final String imageUrl;
  final String audioUrl;

  const MateRoomScreen({super.key, required this.mateName,required this.imageUrl, required this.audioUrl, required this.profileImageUrl, });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<MateRoomScreen> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.imageUrl),
          ],
        ),
      ),
    );
  }
}
