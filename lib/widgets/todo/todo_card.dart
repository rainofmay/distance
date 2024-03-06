import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

// import 'package:uuid/uuid.dart';
//
// var uuid = Uuid();

class TodoCard extends StatefulWidget {
  final String id;
  final String todoName;
  final DateTime selectedDate;
  final bool isDone;
  final List<dynamic> subTodoList;

  TodoCard({
    required this.id,
    required this.todoName,
    required this.selectedDate,
    required this.isDone,
    required this.subTodoList,
    super.key,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  // final _formKey = GlobalKey<FormState>();
  late bool _isDone; // to-do 완료 여부
  late List<dynamic> _subTodoList = [];
  late bool _subIsDone; // 하위 to-do 완료 여부

  late TextEditingController _editingController; // 수정 중인 항목의 컨트롤러
  late int _editingIndex; // 수정 중인 항목의 인덱스
  late bool _isEditing; // 수정 모드 여부

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
    _subIsDone = false;
    _subTodoList = widget.subTodoList;
    _isEditing = false;
    _editingController = TextEditingController();
  }

  //TextEditingController가 더 이상 필요하지 않을 때 해당 컨트롤러를 정리하는데 사용
  // @override
  // void dispose() {
  //   _editingController.dispose();
  //   super.dispose();
  // }

  _updateToggle(newValue) async {
    print('updateToggle: $newValue');
    setState(() {
      _isDone = newValue;
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'isDone': _isDone});
  }

  //하위 to-do 완료여부 업데이트
  _updateSubToggle(index, newValue) async {
    setState(() {
      _subTodoList[index]["subIsDone"] = newValue;
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'subTodoList': _subTodoList});
  }

  // 하위항목 to-do 추가
  _addSubTodo(newValue, boolValue) async {
    setState(() {
      _subTodoList.insert(0, {"title": newValue, "subIsDone": boolValue});
      print(_subTodoList);
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'subTodoList': _subTodoList});
  }

  // 하위항목 to-do 수정
  _editSubTodo(index, editedTitle, editValue) async {
    setState(() {
      _subTodoList[index] = {"title": editedTitle, "subIsDone": editValue};
    });
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(widget.id)
        .update({'subTodoList'[index]: _subTodoList});
  }

  void _startEditing(index) {
    setState(() {
      _editingIndex = index;
      _editingController = TextEditingController(
          text: _subTodoList[index]["title"]); // 해당 항목의 컨트롤러 생성
      _isEditing = true;
    });
  }

  void _endEditing() {
    setState(() {
      _editingIndex = -1;
      _editingController.dispose(); // 컨트롤러 해제
      _isEditing = false;
    });
  }

  void _saveAndExitEditMode(index) {
    // Save the new value and exit edit mode
    String newTitle = _editingController.text;
    index == _subTodoList.length - 1
        ? _addSubTodo(newTitle, _subIsDone)
        : _editSubTodo(index, newTitle, _subIsDone);
    _endEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: _isDone,
                      onChanged: _updateToggle,
                    ),
                    Text(
                      widget.todoName,
                      style: TextStyle(color: BLACK),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.bookmark_border_rounded))
            ],
          ),

          // 하위항목 to-do
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _subTodoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _startEditing(index); // 수정 모드 시작
                    },
                    leading: _subTodoList.length - 1 == index
                        ? IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {},
                            icon: Icon(
                              Icons.subdirectory_arrow_right_rounded,
                              color: Colors.grey,
                              size: 14,
                            ))
                        : Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              splashRadius: 0,
                              hoverColor: Colors.transparent,
                              value: _subTodoList[index]["subIsDone"],
                              onChanged: _isEditing && index == _editingIndex
                                  ? null
                                  : (value) => {_updateSubToggle(index, value)},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                // side: BorderSide(color: Colors.red), // 선택 사항: 체크박스 테두리 설정
                              ),
                            ),
                          ),
                    title: _isEditing &&
                            index == _editingIndex // 수정 모드 활성화, 인덱스 일치할 때만
                        ? TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: _editingController,
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _saveAndExitEditMode(index);
                              }
                            },
                            autofocus: true,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black, fontSize: 11),
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: '하위항목 추가.',
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            ),
                          )
                        : Text(_subTodoList[index]["title"],
                            style: _subTodoList[index]["subIsDone"]
                                ? TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey)
                                : TextStyle(decoration: TextDecoration.none)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
