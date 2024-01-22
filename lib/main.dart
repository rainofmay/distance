import 'package:flutter/material.dart';
import 'package:mobile/util/globalPlayer.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/pages/myroom.dart';
import 'package:mobile/pages/groupstudy.dart';
import 'package:mobile/pages/mate.dart';
import 'package:mobile/pages/store.dart';
import 'package:mobile/pages/etc.dart';
import 'package:mobile/widgets/main_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/global_player.dart';
import 'package:mobile/util/bottom_index.dart';
import 'package:mobile/util/schedule_bottom_index.dart';
import 'package:mobile/util/calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:mobile/util/backgroundProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalAudioPlayer()),
        // ChangeNotifierProvider(create: (context)=> BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => Store1()),
        ChangeNotifierProvider(create: (context)=> BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => Store2()),
      ],
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
  final List screens = [MyRoom(), GroupStudy(), Mate(), Store(), Etc()];

  @override
  Widget build(BuildContext context) {
    // var a = context.watch<Store1>().bottomIndex;
    return Scaffold(
      // appBar: AppBar(),
      body: screens[context.watch<Store1>().bottomIndex],
      bottomNavigationBar: MainBottomNavagationBar(),
    );
  }
}

class Store1 extends ChangeNotifier {
  int bottomIndex = 0;

  setBottomIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }
}