import 'package:flutter/material.dart';

class BackgorundSetting extends StatelessWidget {


  const BackgorundSetting({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Background Setting')),
        body: Center(
            child: ElevatedButton(
          onPressed: () {},
          child: Text('Close'),
        )));
  }
}
