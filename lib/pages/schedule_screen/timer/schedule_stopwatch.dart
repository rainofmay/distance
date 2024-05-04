import 'package:flutter/material.dart';
import 'package:mobile/pages/schedule_screen/timer/stopwatch_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountUpTimer extends StatefulWidget {
  const CountUpTimer({super.key});

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CountUpTimer(),
      ),
    );
  }

  @override
  State<CountUpTimer> createState() => _CountUpTimerState();
}

class _CountUpTimerState extends State<CountUpTimer> {
  final _isHours = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStopped
        .listen((value) => print('stopped from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// Display stop watch time
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data!;
                final displayHour = StopWatchTimer.getDisplayTime(value,
                    hours: _isHours,
                    minute: false,
                    second: false,
                    milliSecond: false);
                //milliSecond: false 는 소수점 단위 삭제
                final displayMinute = StopWatchTimer.getDisplayTime(value,
                    hours: !_isHours,
                    minute: true,
                    second: false,
                    milliSecond: false);
                final displaySecond = StopWatchTimer.getDisplayTime(value,
                    hours: !_isHours,
                    minute: false,
                    second: true,
                    milliSecond: false);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                            child: Text(
                              displayHour,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  height: 1.0,
                                  letterSpacing: 1.2,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          'Hours',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 30),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                            child: Text(
                              displayMinute,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          'Minutes',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 30),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black,
                            ),
                            child: Text(
                              displaySecond,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          'Seconds',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            /// Lap time.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 100,
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    if (value.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);
                      });
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),
            ),

            //스톱워치 조작 버튼
            SizedBox(
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StopWatchButton(
                      onPressedFunction: _stopWatchTimer.onStartTimer,
                      buttonName: '시작'),
                  StopWatchButton(
                      onPressedFunction: _stopWatchTimer.onStopTimer,
                      buttonName: '일시정지'),
                  StopWatchButton(
                      onPressedFunction: _stopWatchTimer.onAddLap,
                      buttonName: '기록'),
                  StopWatchButton(
                      onPressedFunction: _stopWatchTimer.onResetTimer,
                      buttonName: '기록 초기화'),
                  StopWatchButton(
                      onPressedFunction: _stopWatchTimer.clearPresetTime,
                      buttonName: '초기화'),
                ],
              ),
            ),
          ]),
    )));
  }
}
