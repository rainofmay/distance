import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/todo_model.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/todo/todo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ScheduleTodo extends StatefulWidget {
  const ScheduleTodo({super.key});

  @override
  State<ScheduleTodo> createState() => _ScheduleTodoState();
}

class _ScheduleTodoState extends State<ScheduleTodo>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  bool isDone = false;
  bool isBookMarked = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoController = TextEditingController();
  late TabController _tabController;
  final List<dynamic> _categories = [];

  List<Map<String, dynamic>> todoList = [];

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void sendTodo() async {
    if (_formKey.currentState!.validate()) {
      // 유효성 검사 통과한 경우에만 저장
      _formKey.currentState!.save();
    }
    // final String todo = _todoController.text;
    // setState(() {
    //   todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
    // });
    // _todoController.text = '';


    //supabase
    final todo = TodoModel(id: Uuid().v4(), todoName: _todoController.text, isDone: isDone, isBookMarked: isBookMarked);
    try {
      await supabase.from('todo').insert(todo.toJson());
    } catch (error) {
      print('todo insert 에러 $error');
    }
    _todoController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                return null;
              },),
              SizedBox(
                height: 70,
                width: 70,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                    Icon(Icons.add_box_outlined, size: 35),
                      Text('목록')
                  ],),
                ),
              )
            ],
          ),
        ),
        BorderLine(lineHeight: 8, lineColor: Colors.grey.shade300),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              Expanded(
                child: TabBar(
                  tabs: [
                    Tab(
                      height: 40,
                      child: Text('진 행'),
                    ),
                    Tab(
                      height: 40,
                      child: Text('완 료'),
                    ),
                    Tab(
                      height: 40,
                      child: Text('중 요'),
                    )
                  ],
                  splashBorderRadius: BorderRadius.circular(0),
                  indicatorWeight: 1,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
        BorderLine(lineHeight: 10, lineColor: Colors.transparent),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                // color: Colors.yellow[200],
                alignment: Alignment.center,
                child: Todo(),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Tab2 View',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Tab3 View',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 15),
            child: TextFormField(
              controller: _todoController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().isEmpty) {
                  return null;
                }
                return null;
              },
              onFieldSubmitted: (value) => sendTodo(),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: Colors.black, fontSize: 13),
              maxLength: 100,
              textInputAction: TextInputAction.newline, // 다음줄로 넘어가는 키보드
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: sendTodo,
                    icon: Icon(Icons.send, size: 18)),
                hintText: '할 일을 입력해 보세요.',
                counterText: '',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
