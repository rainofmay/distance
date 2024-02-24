import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/util/background_provider.dart';
import 'package:mobile/util/background_setting_provider.dart';

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
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mobile/util/background_setting_provider.dart';

Future<void> main() async {
  List<List<String>> groupedAudioURLs = [
    ['assets/audios/defaultMain.mp3', ''],
    ['', ''],
  ];
  //플러터 프레임워크가 준비될 때까지 대기
  bool isRight = false;
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalAudioPlayer(groupedAudioURLs)),
        ChangeNotifierProvider(create: (context)=> BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => Store1()),
        ChangeNotifierProvider(create: (context)=> BackgroundSettingProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainPage(),
          theme: mainstyle.theme),
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  final List screens = [MyRoom(), GroupStudy(), Mate(), Store(), LoginPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: screens[context.watch<Store1>().bottomIndex],
      bottomNavigationBar: MainBottomNavagationBar(),
    );
  }
}

