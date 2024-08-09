import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
   final double size;
   const CustomCircularIndicator({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0, // 선의 두께
          backgroundColor: Colors.grey[200], // 배경색
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // 진행 색상
        ),
      ),
    );
  }
}
