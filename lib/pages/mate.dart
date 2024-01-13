import 'package:flutter/material.dart';

class Mate extends StatefulWidget {
  const Mate({super.key});

  @override
  State<Mate> createState() => _MateState();
}

class _MateState extends State<Mate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('메이트'),
      ),
      body: Center(child: Text('CLED MATE',style: TextStyle(fontSize: 40))),
    );
  }
}
