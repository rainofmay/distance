import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/myroom_calendar.dart';
import 'package:mobile/widgets/schedule_bottom_bar.dart';
class Schedule extends StatefulWidget {
  // final VoidCallback closeContainer;
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  TextEditingController introduceController = TextEditingController();
  bool isCalendarOpen = false;

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

  // 날짜 선택할 때마다 실행되는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      print(selectedDate.day);
      print(DateTime.now().day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('뒤로가기'),),
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
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 0),
                child: IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.white70, size: 20,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // 달력 큰제목
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  months[DateTime.now().month - 1],
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 10, fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 20, top: 15, bottom: 15),
                child: Text(
                  '${DateTime.now().day}'.length == 2 ? '${DateTime.now().day}' : '0'+'${DateTime.now().day}',
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 10, fontSize: 16),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:10, bottom: 10, left:30, right:30),
                // margin: EdgeInsets.only(top:10, bottom: 10),
                child: Calendar(
                  selectedDate: selectedDate,
                  onDaySelected: onDaySelected,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('My day', style: TextStyle(color: Colors.white)),),

              //일정 리스트
              Container(
                margin: EdgeInsets.only(top: 15),

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [

                    ],
                  ),
                ),
              ),
              SizedBox(
                // margin: EdgeInsets.symmetric(vertical: 8),
                // height: 40,
                child: TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    maxLength: 100,
                    controller: introduceController,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.calendar_month_outlined, size: 18),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.send, size: 18),
                        ),
                        hintText: '일정을 입력하세요.',
                        // labelText: '메모 입력',
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide.none))),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ScheduleBottomNavigationBar(),
    );
  }
}
