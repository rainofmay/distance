import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/model/todo_model.dart';
import 'package:mobile/widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

final firestore = FirebaseFirestore.instance;

class TodoBottomSheet extends StatefulWidget {
  const TodoBottomSheet({super.key});

  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _todoName = '';
  final  List<dynamic> _subTodoList = [{"title": "하위항목 추가", "completed" : false}];
  DateTime _selectedDate = DateTime.now();
  final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());
  bool _isDone = false;

  void onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    //스케줆 모델 생성
    final todo = TodoModel(
        id: Uuid().v4(),
        todoName: _todoName,
        selectedDate: _selectedDate,
        timeStamp: _timeStamp,
        isDone: _isDone,
        subTodoList: _subTodoList);

    await firestore.collection('todo').doc(todo.id).set(todo.toJson());
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2999));
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
        child: Form(
      key: _formKey,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.8 + bottomInset,
          color: WHITE,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: '할일 제목',
                      hint: '입력된 거 또는 빈 칸',
                      maxiLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "한 글자 이상 입력하세요.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          _todoName = val as String;
                        });
                      },
                    ),
                    // CustomTextField(
                    //   label: '메 모',
                    //   hint: '메모를 입력해 보세요.',
                    //   onSaved: (value) {
                    //     setState(() {
                    //       _memo = value as String;
                    //     });
                    //   },
                    // ),
                    CustomTextField(
                      label: '날 짜',
                      hint: DateFormat.yMd().format(_selectedDate),
                      widget: IconButton(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: _getDateFromUser),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      // height: 30,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop(); // 닫히는 버튼
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              onSavePressed();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Color(0xff0029F5)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}
