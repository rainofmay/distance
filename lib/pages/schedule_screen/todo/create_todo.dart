import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../const/colors.dart';
import '../../../model/todo_model.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';
import '../../../widgets/custom_text_field.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _textFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _subTextController =
      TextEditingController(); // 한개로 해도 되려나???

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    _textController.dispose();
    // _textFocus.dispose();
    super.dispose();
  }

  String _todoName = '';
  final List<dynamic> _subTodoList = [];
  final bool _isDone = false;

  late int _editingIndex; // 수정 중인 항목의 인덱스
  late bool _isEditing = false; // 수정 모드 여부
  late TextEditingController _editingController; // 수정 중인 항목의 컨트롤러

  void _startEditing(index) {
    setState(() {
      _editingIndex = index;
      _editingController = TextEditingController(
          text: _subTodoList[index]["title"]); // 해당 항목의 컨트롤러 생성
      _isEditing = true;
    });
  }

  // _updateSubToggle(index, newValue) async {
  //   setState(() {
  //     _subTodoList[index]["subIsDone"] = newValue;
  //   });
  //   await supabase
  //       .from('todo')
  //       .update({'sub_todo_list': _subTodoList}).eq('id', widget.id);
  // }
  //
  // // 하위항목 to-do 추가
  // _addSubTodo(newValue, boolValue) async {
  //   setState(() {
  //     _subTodoList.insert(0, {"title": newValue, "subIsDone": boolValue});
  //     print(_subTodoList);
  //   });
  //   await supabase
  //       .from('todo')
  //       .update({'sub_todo_list': _subTodoList})
  //       .eq('id', widget.id);
  // }
  //
  // // 하위항목 to-do 수정
  // _editSubTodo(index, editedTitle, editValue) async {
  //   setState(() {
  //     _subTodoList[index] = {"title": editedTitle, "subIsDone": editValue};
  //   });
  //   await supabase
  //       .from('todo')
  //       .update({'sub_todo_list'[index]: _subTodoList})
  //       .eq('id', widget.id);
  // }
  //
  // void _saveAndExitEditMode(index) {
  //   // Save the new value and exit edit mode
  //   String newTitle = _editingController.text;
  //   index == _subTodoList.length - 1
  //       ? _addSubTodo(newTitle, _subIsDone)
  //       : _editSubTodo(index, newTitle, _subIsDone);
  //   _endEditing();
  // }

  void _onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    Navigator.of(context).pop();

    //to-do 모델 생성
    final todo = TodoModel(
        id: Uuid().v4(),
        todoName: _todoName,
        // selectedDate: _selectedDate,
        isDone: _isDone,
        subTodoList: _subTodoList);

    try {
      print('todo 모델 $todo');
      await supabase.from('todo').insert(todo.toJson());
    } catch (error) {
      print('to-do insert 에러 $error');
    }
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
              valueListenable: _textController,
              builder: (BuildContext context, value, Widget? child) {
                return TextButton(
                    onPressed: (value.text.isEmpty)
                        ? null
                        : () => {
                              _onSavePressed(),
                            },
                    child: Text('저장',
                        style: TextStyle(
                            color: value.text.isEmpty ? UNSELECTED : WHITE)));
              },
            )
          ],
        ),
        body: SafeArea(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: _textController,
                  autofocus: true,
                  readOnly: false,
                  titleIcon: Icon(Icons.library_add_check_rounded),
                  hint: '할 일을 입력해 주세요.',
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      _todoName = val as String;
                    });
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_textFocus);
                      },
                      child: ListTile(
                        leading: Text('#', style: TextStyle(fontSize: 18)),
                        title: TextFormField(
                          focusNode: _textFocus,
                          textInputAction: TextInputAction.done,
                          controller: _subTextController,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          // maxLength: 20,
                          decoration: InputDecoration(
                            hintText: '하위항목 추가',
                            counterText: '',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add_circle_outline_rounded),
                          onPressed: () {},
                        ),
                      ),
                    )),
                // Expanded(
                //   child: Padding(
                //     padding:
                //     const EdgeInsets.only(top: 2, bottom: 2, left: 8),
                //     child: ListView.builder(
                //       shrinkWrap: true,
                //       scrollDirection: Axis.vertical,
                //       itemCount: _subTodoList.length,
                //       itemBuilder: (context, index) {
                //         return ListTile(
                //           onTap: () {
                //             _startEditing(index); // 수정 모드 시작
                //           },
                //           leading: _textFocus.hasFocus
                //               ? Transform.scale(
                //             scale: 0.8,
                //             child: Checkbox(
                //               splashRadius: 0,
                //               hoverColor: Colors.transparent,
                //               value: _subTodoList[index]["subIsDone"],
                //               onChanged: null,
                //               // _isEditing && index == _editingIndex
                //               //     ? null
                //               //     : (value) => {_updateSubToggle(index, value)},
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(50),
                //                 // side: BorderSide(color: Colors.red), // 선택 사항: 체크박스 테두리 설정
                //               ),
                //             ),
                //           ) : IconButton(
                //               splashColor: Colors.transparent,
                //               highlightColor: Colors.transparent,
                //               hoverColor: Colors.transparent,
                //               onPressed: () {},
                //               icon: Icon(
                //                 Icons.add_circle_outline_rounded,
                //                 color: Colors.grey,
                //                 size: 14,
                //               )),
                //           title: _isEditing &&
                //         index == _editingIndex // 수정 모드 활성화, 인덱스 일치할 때만
                //         ? TextFormField(
                //         focusNode: _textFocus,
                //           textInputAction: TextInputAction.done,
                //           controller: _editingController,
                //           // onFieldSubmitted: (value) {
                //           //   if (value.isNotEmpty) {
                //           //     _saveAndExitEditMode(index);
                //           //   }
                //           // },
                //           autofocus: true,
                //           textAlign: TextAlign.start,
                //           style: TextStyle(
                //               color: Colors.black, fontSize: 11),
                //           maxLength: 20,
                //           decoration: InputDecoration(
                //             hintText: _textFocus.hasPrimaryFocus
                //                 ? '하위항목 추가'
                //                 : null,
                //             counterText: '',
                //             border: const OutlineInputBorder(
                //                 borderRadius: BorderRadius.zero,
                //                 borderSide: BorderSide.none),
                //           ),
                //         ): Text(_subTodoList[index]["title"],
                //         style: _subTodoList[index]["subIsDone"]
                //         ? TextStyle(
                //         decoration: TextDecoration.lineThrough,
                //         color: Colors.grey)
                //             : TextStyle(decoration: TextDecoration.none)),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        )));
  }
}
