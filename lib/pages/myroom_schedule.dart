import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {

  const Schedule({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Schedule Setting')),
        body: Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Close'),
            )));
  }
}
