import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../const/colors.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';
import '../../../widgets/borderline.dart';
import '../../../widgets/custom_text_field.dart';

class ModifyTodo extends StatefulWidget {
  const ModifyTodo({super.key});

  @override
  State<ModifyTodo> createState() => _ModifyTodoState();
}

class _ModifyTodoState extends State<ModifyTodo> {
  late String _title; // 할일 제목, provider 저장
  late String _memo; // 메모, provider 저장

  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _titleController = TextEditingController(
    //     text: context.read<ModifyingScheduleProvider>().modifyingName);
    // _memoController = TextEditingController(
    //     text: context.read<ModifyingScheduleProvider>().modifyingMemo);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onSavePressed() async {
    // if (_formKey.currentState!.validate()) {
    //   // bool값 리턴
    //   _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBackAppBar(
          isLeading: true,
          appbarTitle: '',
          backFunction: Navigator.of(context).pop,
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [
            ValueListenableBuilder(
              valueListenable: _titleController,
              builder: (BuildContext context, TextEditingValue value,
                  Widget? child) {
                return TextButton(
                  onPressed: (value.text.isEmpty)
                      ? null
                      : () => {
                            _onSavePressed(),
                          },
                  child: Text(
                    '수정',
                    style: TextStyle(
                        color: value.text.isEmpty ? UNSELECTED : WHITE),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () async {
                // await supabase.from('schedule').delete().match({
                //   'id': context
                //       .read<ModifyingScheduleProvider>()
                //       .modifyingScheduleId
                // });
                // if (!context.mounted) return;
                // context.read<CalendarProvider>().setSelectedDate(
                //     _startDate);
                // Navigator.of(context).pop();
              },
              child: Text(
                '삭제',
                style: TextStyle(
                    color: Color(0xffc41b03), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: SafeArea(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                        padding:
                            // appBar와 body 간의 간격
                            EdgeInsets.only(
                          left: 8.0,
                          top: 16.0,
                        ),
                        child: Column(children: [
                          CustomTextField(
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            readOnly: false,
                            controller: _titleController,
                            hint: '할 일을 입력해 주세요.',
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            maxLines: 1,
                            maxLength: 13,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                _title = val as String;
                              });
                            },
                          ),
                          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
                          ListTile(
                            title: Text('북마크 설정'),
                            trailing: IconButton(icon: Icon(Icons.bookmark_border_rounded),
                              onPressed: () {}),
                          ),
                          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
                          ListTile(
                            title: Text('메이트 공유'),
                            trailing: IconButton(icon: Icon(CupertinoIcons.person_add_solid),
                                onPressed: () {}),
                          ),
                        ]))))));
  }
}
