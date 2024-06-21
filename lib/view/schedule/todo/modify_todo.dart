import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/const/colors.dart';
import '../../../model/todo_model.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';
import '../../../widgets/borderline.dart';
import '../../../widgets/custom_text_field.dart';

class ModifyTodo extends StatefulWidget {
  const ModifyTodo({super.key});

  @override
  State<ModifyTodo> createState() => _ModifyTodoState();
}

class _ModifyTodoState extends State<ModifyTodo> {

  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController _titleController;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSavePressed(String id, String todoName, bool isDone, bool isBookMarked) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final todo = TodoModel(
        id: id,
        todoName: todoName,
        isDone: isDone,
        isBookMarked: isBookMarked,
      );

      try {
        await Supabase.instance.client
            .from('todo')
            .update(todo.toJson())
            .eq('id', todo.id);
      } catch (error) {
        print('에러 $error');
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  void _setBookMark(bool value) {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>; // todo.dart에서 값 받아오기
    _titleController = TextEditingController(text: args['todoName'] as String); // 텍스트필드 값(to-do 제목) 가져오기
    // boolValue = isBookMarked;

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
                      : () => _onSavePressed(
                            args['id'] as String,
                            _titleController.text,
                            args['isDone'] as bool,
                            args['isBookMarked'] as bool,
                          ),
                  child: Text(
                    '수정',
                    style: TextStyle(
                        color: value.text.isEmpty ? GREY : WHITE),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () async {
                await supabase.from('todo').delete().match({'id': args['id']});
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text(
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
                            const EdgeInsets.only(
                          left: 8.0,
                          top: 16.0,
                        ),
                        child: Column(children: [
                          CustomTextField(
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            readOnly: false,
                            controller: _titleController,
                            hint: '할 일을 입력해 주세요',
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            maxLines: 1,
                            maxLength: 13,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                          ),
                          // BorderLine(
                          //     lineHeight: 1,
                          //     lineColor: Colors.grey.withOpacity(0.1)),
                          // ListTile(
                          //   title: const Text('북마크 설정'),
                          //   trailing: IconButton(
                          //       icon: Icon(boolValue == true ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark),
                          //       onPressed: () {
                          //         print(boolValue);
                          //         setState(() {
                          //           boolValue = !boolValue;
                          //         });
                          //         print(boolValue);
                          //       }),
                          // ),
                          BorderLine(
                              lineHeight: 1,
                              lineColor: Colors.grey.withOpacity(0.1)),
                          ListTile(
                            title: const Text('메이트 공유'),
                            trailing: IconButton(
                                icon: const Icon(CupertinoIcons.person_add),
                                onPressed: () {}),
                          ),
                          BorderLine(
                              lineHeight: 1,
                              lineColor: Colors.grey.withOpacity(0.1)),
                        ]))))));
  }
}
