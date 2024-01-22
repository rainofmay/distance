import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/myroom_calendar.dart';
import 'package:mobile/widgets/schedule_todo.dart';
import 'package:mobile/util/calendar.dart';
import 'package:provider/provider.dart';

class ScheduleTodo extends StatefulWidget {
  const ScheduleTodo({super.key});

  @override
  State<ScheduleTodo> createState() => _ScheduleTodoState();
}

class _ScheduleTodoState extends State<ScheduleTodo> {
  List<String> months = [
    'Jan',
    'Fab',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDate = DateTime.now();
  // 날짜 선택할 때마다 실행되는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      this.focusedDate = focusedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/test2.jpg'),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 6),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              // 달력 큰제목
              Expanded(
                // 아래 TextField 에러 사라짐.
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 15, right: 20),
                      child: Text(
                        months[DateTime.now().month - 1],
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 10,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 15, right: 22),
                      child: Text(
                        '${DateTime.now().day}'.length == 2
                            ? '${DateTime.now().day}'
                            : '0 ${DateTime.now().day}',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height:
                          context.watch<CalendarProvider>().isCalendarVisible
                              ? 250
                              : 0,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 25, bottom: 10, left: 30, right: 30),
                        // margin: EdgeInsets.only(top:10, bottom: 10),
                        child:
                            context.watch<CalendarProvider>().isCalendarVisible
                                ? SingleChildScrollView(
                                    child: Calendar(
                                      focusedDate: focusedDate,
                                      selectedDate: selectedDate,
                                      onDaySelected: onDaySelected,
                                    ),
                                  )
                                : null,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 30,
                margin: EdgeInsets.only(top: 30),
                child: Text(
                    selectedDate.day == DateTime.now().day
                        ? 'Today'
                        : '${selectedDate.month}월 ${selectedDate.day}일',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w100, fontSize: 14)),
              ),

              //일정(TO-do) 리스트
              Container(
                margin: EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Todo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
