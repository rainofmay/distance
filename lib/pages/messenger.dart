import 'package:flutter/material.dart';

class Messenger extends StatefulWidget {
  const Messenger({super.key});

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('메신저'),
      ),
      body: Center(child: Text('CLED MATE',style: TextStyle(fontSize: 40))),
    );
  }
}
