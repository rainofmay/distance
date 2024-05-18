import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  final List<dynamic> _categories = [];

  List<Map<String, dynamic>> todoList = [];

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _scrollController.addListener(() {
      /// 스크롤을 할 때 마다 호출

      /// 스크롤 된 값
      print('offset : ${_scrollController.offset}');

      /// 스크롤에 대한 여러 정보.
      /// 전체 길이, offset, 방향 등
      print('position : ${_scrollController.position}');

      /// 컨트롤러가 SingleChildScrollView에 연결이 됐는지 안돼는지
      _scrollController.hasClients;
    });

    super.initState();
  }

  @override
  void dispose() {
    _todoController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

 _scrollToCursor() {
    final cursorPosition = _todoController.selection.baseOffset.toDouble();
    final scrollPosition = _scrollController.position;
    final maxHeight = scrollPosition.maxScrollExtent;

    if (cursorPosition > maxHeight) {
      print(maxHeight);
      _scrollController.jumpTo(maxHeight);
    } else {
      print(cursorPosition);
      _scrollController.jumpTo(cursorPosition);
    }
  }

  void sendTodo() async {
    if (_todoController.text.trim().isEmpty) {
      return; // 입력값이 비어 있다면 아무 작업도 수행하지 않음
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    // final String todo = _todoController.text;
    // setState(() {
    //   todoList.add({"todo": todo, "completed": false}); // to-do 리스트에 항목 추가
    // });
    // _todoController.text = '';


    //supabase
    final todo = TodoModel(id: Uuid().v4(),
        todoName: _todoController.text,
        isDone: false,
        isBookMarked: false);
    try {
      await supabase.from('todo').insert(todo.toJson());
    } catch (error) {
      print('todo insert 에러 $error');
    }
    _todoController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        onTap: () {},
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                    ),
                    Expanded(
                      child: TabBar(
                        tabs: [
                          const Tab(
                            height: 40,
                            child: Text('진 행'),
                          ),
                          const Tab(
                            height: 40,
                            child: Text('완 료'),
                          ),
                          const Tab(
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
              BorderLine(lineHeight: 10, lineColor: TRANSPARENT),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      // color: Colors.yellow[200],
                      alignment: Alignment.center,
                      child: Todo(column: 'is_done', columnValue: false),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Todo(column: 'is_done', columnValue: true),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Todo(column: 'is_book_marked', columnValue: true),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
              )
            ]
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -15,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Container(
                height: 75,
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _todoController,
                  focusNode: _focusNode,
                  onChanged: (value) => _scrollToCursor,
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  //바깥 터치했을 떄 키보드 감추기
                  maxLines: null,
                  maxLength: 100,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: BLACK, fontSize: 13),
                  textInputAction: TextInputAction.newline,
                  // 다음줄로 넘어가는 키보드
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        highlightColor: TRANSPARENT,
                        hoverColor: TRANSPARENT,
                        splashRadius: null,
                        onPressed: sendTodo,
                        icon: const Icon(Icons.send, size: 18)),
                    hintText: '할 일을 입력해 보세요.',
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]
    );
  }
}
