import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
          // centerTitle: true,
        title: Text('스토어'),
        leading: Image(image:AssetImage('assets/images/store.png',),), // 캐릭터
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search,),),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        ],

      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(child: Text('광고',style: TextStyle(fontSize: 40))),
          Container(child: Text('테마1',style: TextStyle(fontSize: 40))),
          Container(child: Text('테마2',style: TextStyle(fontSize: 40))),
        ],
      ),
    );
  }
}
