import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/bottom_bar.dart';
import 'package:mobile/main.dart';
import 'package:provider/provider.dart';

class Memo extends StatefulWidget {
  // final VoidCallback closeContainer;

  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  TextEditingController introduceController = TextEditingController();
  // bool isEditmode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: Text(
                '메모하기',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                      size: 20,
                    ))
              ],
            ),
          ],
        ),
      ), // leading: Container(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            // margin: EdgeInsets.symmetric(vertical: 8),
            // height: 40,
            child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 13),
                maxLength: 100,
                controller: introduceController,

                decoration: InputDecoration(
                  prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, size: 18),),
                  suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.send, size: 18),),
                    hintText: '메모를 입력하세요.',
                    // labelText: '메모 입력',
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none))),
          ),
        ],
      ),
    );
  }
}
