import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  //연속된 여러 번의 호출 중 마지막 호출만 실행
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 300});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}