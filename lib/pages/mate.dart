import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mate extends StatefulWidget {
  const Mate({super.key});

  @override
  State<Mate> createState() => _MateState();
}


// 더미 데이터
final List<String> dummyFriendList = ['friend1', 'friend2', 'friend3'];
final List<String> dummySentRequests = ['request1', 'request2'];
final List<String> dummyReceivedRequests = ['request3', 'request4'];

Future<List<String>> fetchFriendList(String userId) async {
  return Future.delayed(Duration(seconds: 1), () {
    return dummyFriendList;
  });
}

// 사용자가 보낸 친구 요청 목록을 가져오는 함수
Future<List<String>> fetchSentFriendRequests(String userId) async {
  return Future.delayed(Duration(seconds: 1), () {
    return dummySentRequests;
  });
}

// 사용자가 받은 친구 요청 목록을 가져오는 함수
Future<List<String>> fetchReceivedFriendRequests(String userId) async {
  return Future.delayed(Duration(seconds: 1), () {
    return dummyReceivedRequests;
  });
}

class _MateState extends State<Mate> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mate Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '친구 목록',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FriendList(),
          ),
        ],
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: dummyFriendList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(dummyFriendList[0]),
              subtitle: Text(dummyFriendList[0]),
            );
          },
        );
      },
    );
  }
}