import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  DateTime nowTime = DateTime.now();
  //현재 값으로 설정한 것이지, 이게 최종 값은 아니다. 최종 값으로는 설정한 날로 해줄 것.
  File? image;
  List<XFile?> multiImage = [];
  List<XFile?> images = [];
  late int DDay;
  String DDayString = "";
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
      vsync: this,

    );


    super.initState();
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController maxMembersController = TextEditingController();
    TextEditingController studyTimeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
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
                    SizedBox(
                      height: 23.0, // 높이를 조절하여 간격을 만듭니다.
                    ),
                    Text("디데이 설정",style : TextStyle(fontSize: 18,)),
                    SizedBox(
                      height: 20.0, // 높이를 조절하여 간격을 만듭니다.
                    ),
                    SizedBox(
                        width: 250,
                        height: 100,
                        child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (DateTime date) {
                              setState(() {
                                selectedDate = date;
                                DDay = DateTime(
                                  nowTime.year, // DateTime 안에서 year, month, day 값을 받아온 뒤
                                  nowTime.month,
                                  nowTime.day,
                                ).difference(selectedDate).inDays + 1;
                                if(DDay >= 0) {
                                  DDayString = '+ $DDay';
                                }else{
                                  DDayString = '$DDay';
                                }
                              });
                              ;
                            })),
                    SizedBox(
                      height: 16.0, // 높이를 조절하여 간격을 만듭니다.
                    ),
                    Text('D-DAY: ${selectedDate.year}.${selectedDate.month}.${selectedDate.day}', style: TextStyle(color:Colors.red),),
                    SizedBox(
                      height: 16.0, // 높이를 조절하여 간격을 만듭니다.
                    ),
                    Text('D$DDayString'),
                    // 사진 image_picker로 수정
                    Text("스터디룸 사진 설정",style: TextStyle(fontSize: 20),),

                    image == null
                        ? Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  if (pickedFile != null) {
                                    image = File(pickedFile.path);
                                    print("image File Path : $image");
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(image!.path)),
                              ),
                            ),
                          ),
                    TextFormField(
                      controller: maxMembersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "최대 인원 수"),
                    ),
                    // 주요 공부시간대 설정
                    TextFormField(
                      controller: studyTimeController,
                      decoration: InputDecoration(labelText: "주요 공부 시간"),
                    ),
                    // 추가로 뭘 더 들어가야 할지 설정
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      image = null;
                    });
                  },
                  child: Text("취소"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // CreateGroup 함수 호출
                    _createGroup(
                      nameController.text,
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
      },
    );
  }

  void _createGroup(String name, int maxMembers, String studyTime) {
    // 그룹 생성 로직을 여기에 구현
    print('Creating group with: $name, $maxMembers, $studyTime');
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
                  height: 40,
                  child: Text(
                    '전체 보기',
                  ),
                ),
                Tab(
                  height: 40,
                  child: Text(
                    '참여 중',
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              splashBorderRadius: BorderRadius.circular(0),
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              dividerColor: Colors.transparent,
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
                    itemCount: groupStudyNames.length + 1,
                    // +1 for "그룹 생성하기" 버튼
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
  final File? image;
  final imageAsset;

  GroupStudyCard({
    Key? key,
    required this.name,
    required this.onPressed,
    this.image,
    this.imageAsset,
  });

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

  AddGroupButton({Key? key, required this.onPressed});

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
