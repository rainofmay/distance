import 'package:flutter/material.dart';

class Etc extends StatefulWidget {
  const Etc({super.key});

  @override
  State<Etc> createState() => _EtcState();
}

class _EtcState extends State<Etc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('더보기'),
      ),
      body: Center(child: Text('ETC',style: TextStyle(fontSize: 40))),
    );
  }
}

