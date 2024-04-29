import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../const/colors.dart';
import '../../../model/todo_model.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';
import '../../../widgets/custom_text_field.dart';

class HandleTodo extends StatefulWidget {
  const HandleTodo({super.key});

  @override
  State<HandleTodo> createState() => _HandleTodoState();
}

class _HandleTodoState extends State<HandleTodo> {
  final _formKey = GlobalKey<FormState>();
  String _todoName = '';
  final List<dynamic> _subTodoList = [
    {"title": "", "subIsDone": false}
  ];
  DateTime _selectedDate = DateTime.now();
  final Timestamp _timeStamp = Timestamp.fromDate(DateTime.now());
  final bool _isDone = false;

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    Navigator.of(context).pop();

    //스케줆 모델 생성
    final todo = TodoModel(
        id: Uuid().v4(),
        todoName: _todoName,
        selectedDate: _selectedDate,
        timeStamp: _timeStamp,
        isDone: _isDone,
        subTodoList: _subTodoList);

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
    return Scaffold(
        appBar: CustomBackAppBar(
          appbarTitle: '',
          backFunction: Navigator.of(context).pop,
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [
            TextButton(
                onPressed: _onSavePressed,
                child: Text(
                  '저장',
                  style: TextStyle(color: WHITE),
                ))
          ],
        ),
        body: SafeArea(
            child: Form(
          key: _formKey,
          child: Container(
              color: WHITE,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        // label: '할일 제목',
                        readOnly: false,
                        hint: '입력된 거 또는 빈 칸',
                        maxLines: 1,
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
                      CustomTextField(
                        // label: '날 짜',
                        readOnly: true,
                        hint: DateFormat.yMd().format(_selectedDate),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              )),
        )));
  }
}
