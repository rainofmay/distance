import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/login/auth_screen.dart';
import 'package:mobile/view/etc.dart';
import 'package:mobile/util/modifying_schedule_provider.dart';
import 'package:mobile/util/schedule_color_provider.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:mobile/viewModel/myroom/music/myroom_music_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/view/myroom/myroom_screen.dart';
import 'package:mobile/view/mate/mateList.dart';
import 'package:mobile/widgets/bottomBar/main_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/bottom_index.dart';
import 'package:mobile/util/calendar_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MyroomMusicViewModel());
  await initializeDateFormatting();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.get("PROJECT_URL"), anonKey: dotenv.get("PROJECT_API_KEY"));

  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => BottomIndex()),
        ChangeNotifierProvider(create: (context) => ScheduleColorProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleEventsProvider()),
        ChangeNotifierProvider(create: (context) => ModifyingScheduleProvider()),
        // ChangeNotifierProvider(create: (context) => ClassBottomIndex()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // initialRoute: '/main',
          // routes: {
          //   '/main' : (context) => MainPage(),
          // },
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
  final List screens = [MyroomScreen(), Mate(), AuthScreen(), Etc()];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: BLACK, // 하단 시스템UI 검정색
    ));

    return Scaffold(
      // appBar: AppBar(),
      body: screens.elementAt(context.watch<BottomIndex>().bottomIndex),
      bottomNavigationBar: MainBottomNavagationBar(),
    );
  }
}
