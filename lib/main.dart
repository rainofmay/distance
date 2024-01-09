import 'package:flutter/material.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/pages/myroom.dart';
import 'package:mobile/pages/groupstudy.dart';
import 'package:mobile/pages/messenger.dart';
import 'package:mobile/pages/store.dart';
import 'package:mobile/pages/etc.dart';
import 'package:mobile/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Store1(),
    child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),
          theme: mainstyle.theme),
  ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List screens = [MyRoom(), GroupStudy(), Messenger(), Store(), Etc()];

  int bottomIndex = 0;

  setBottomIndex(int index) {
    setState(() {
      bottomIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: screens[bottomIndex],
        bottomNavigationBar: CustomBottomNavagationBar(setBottomIndex: setBottomIndex,),
    );
  }
}

class Store1 extends ChangeNotifier {

}
