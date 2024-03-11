import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // 시간:분:초를 저장할 변수
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  // 타이머 작동 여부를 저장할 변수
  bool isRunning = false;

  // 1초마다 시간을 갱신하는 타이머
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타이머'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$hours:$minutes:$seconds',
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: Text('시작'),
                onPressed: isRunning ? null : startTimer,
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                child: Text('멈춤'),
                onPressed: isRunning ? stopTimer : null,
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                child: Text('초기화'),
                onPressed: resetTimer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 타이머 시작
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (seconds >= 60) {
          seconds = 0;
          minutes++;
          if (minutes >= 60) {
            minutes = 0;
            hours++;
          }
        }
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  // 타이머 멈춤
  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // 타이머 초기화
  void resetTimer() {
    timer?.cancel();
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      isRunning = false;
    });
  }
}
