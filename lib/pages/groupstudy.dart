import 'package:flutter/material.dart';

void main() {
  runApp(GroupStudy());
}

class GroupStudy extends StatefulWidget {
  GroupStudy({super.key});

  @override
  State<GroupStudy> createState() => _GroupStudyState();
}

class _GroupStudyState extends State<GroupStudy>
    with SingleTickerProviderStateMixin {
  final List<String> groupStudyNames = [
    'Group Study 1',
    'Group Study 2',
    // Add more group study names as needed
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController maxMembersController = TextEditingController();
    TextEditingController studyTimeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("그룹 생성"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "그룹 이름"),
                ),
                TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: "사진 URL"),
                ),
                TextFormField(
                  controller: maxMembersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "최대 인원 수"),
                ),
                TextFormField(
                  controller: studyTimeController,
                  decoration: InputDecoration(labelText: "주요 공부 시간"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // CreateGroup 함수 호출
                _createGroup(
                  nameController.text,
                  imageUrlController.text,
                  int.tryParse(maxMembersController.text) ?? 0,
                  studyTimeController.text,
                );
              },
              child: Text("생성"),
            ),
          ],
        );
      },
    );
  }

  void _createGroup(
      String name, String imageUrl, int maxMembers, String studyTime) {
    // 그룹 생성 로직을 여기에 구현
    print('Creating group with: $name, $imageUrl, $maxMembers, $studyTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        title: Text('그룹스터디'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              tabs: [
                Tab(
                  height: 80,
                  child: Text(
                    '전체 보기',
                  ),
                ),
                Tab(
                  height: 80,
                  child: Text(
                    '참여 중',
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              overlayColor:  MaterialStatePropertyAll(
                Colors.transparent,
              ),
              splashBorderRadius: BorderRadius.circular(0),
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              controller: _tabController,
              // isScrollable: true,
              onTap: (int i) {
                //tab 전환시 동작할 함수
              },
              // '현재 그룹 수: ${groupStudyNames.length}',
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: groupStudyNames.length + 1, // +1 for "그룹 생성하기" 버튼
                    itemBuilder: (BuildContext context, int index) {
                      if (index == groupStudyNames.length) {
                        return AddGroupButton(onPressed: () {
                          _showCreateGroupDialog(context);
                        });
                      } else {
                        return GroupStudyCard(
                          name: groupStudyNames[index],
                          onPressed: () {
                            // 실행될 함수 호출
                            print('Pressed ${groupStudyNames[index]}');
                          },
                          imageAsset: 'assets/images/backgroundtest1.jpeg',
                        );
                      }
                    },
                  ),
                ),
                Container(
                  color: Colors.green[200],
                  alignment: Alignment.center,
                  child: Text(
                    'Tab2 View',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupStudyCard extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final String imageAsset;

  GroupStudyCard(
      {super.key,
      required this.name,
      required this.onPressed,
      required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              height: 150.0, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}

class AddGroupButton extends StatelessWidget {
  final VoidCallback onPressed;

  AddGroupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
