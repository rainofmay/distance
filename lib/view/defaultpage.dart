import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final VoidCallback closeContainer;

  const DefaultPage({super.key, required this.closeContainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('예외처리')),
        body: Center(
            child: ElevatedButton(
              onPressed: closeContainer,
              child: Text('Close'),
            )));
  }
}
