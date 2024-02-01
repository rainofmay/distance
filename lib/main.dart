import 'package:flutter/material.dart';

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
import 'package:mobile/util/calendar.dart';
import 'package:mobile/util/background_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalAudioPlayer()),
        ChangeNotifierProvider(create: (context)=> BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => Store1()),
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
    return Scaffold(
      // appBar: AppBar(),
      body: screens[context.watch<Store1>().bottomIndex],
      bottomNavigationBar: MainBottomNavagationBar(),
    );
  }
}

