import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: DARK_UNSELECTED,
      body: Center(
        child: Text(
          "Intro Screen",
          style: TextStyle(fontSize: 30, color: PRIMARY_COLOR),
        ),
      ),
    );
  }
}