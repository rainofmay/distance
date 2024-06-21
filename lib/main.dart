import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/login/auth_screen.dart';
import 'package:mobile/util/modifying_schedule_provider.dart';
import 'package:mobile/util/schedule_color_provider.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:mobile/view_model/common/bottom_bar_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/view/myroom/myroom_screen.dart';
import 'package:mobile/view/mate/mateList.dart';
import 'package:provider/provider.dart';
import 'package:mobile/view_model/myroom/music/global_player.dart';
import 'package:mobile/util/calendar_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.get("PROJECT_URL"), anonKey: dotenv.get("PROJECT_API_KEY"));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalAudioPlayer()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleColorProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleEventsProvider()),
        ChangeNotifierProvider(create: (context) => ModifyingScheduleProvider()),
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
  final BottomBarViewModel bottomBarViewModel = Get.put(BottomBarViewModel());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: BLACK, // 하단 시스템UI 검정색
    ));

    return Obx(() => Scaffold(
      // appBar: AppBar(),
        body: bottomBarViewModel.setScreen(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomBarViewModel.bottomIndex,
            onTap: (newIndex) => {
              print('newIndex $newIndex'),
              bottomBarViewModel.setBottomIndex(newIndex)},
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: '내 방',),
              BottomNavigationBarItem(icon: Icon(Icons.person_3), label: '메이트'),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.card_giftcard), label: '스토어'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.login), label: '로그인(임시)'),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: '더보기'),
            ])));
  }
}
