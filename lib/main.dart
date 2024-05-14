import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/util/background_provider.dart';
import 'package:mobile/util/background_setting_provider.dart';
import 'package:mobile/util/modifying_schedule_provider.dart';
import 'package:mobile/util/schedule_color_provider.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'style.dart' as mainstyle;
import 'package:mobile/pages/myroom.dart';
import 'package:mobile/pages/mate.dart';
import 'package:mobile/pages/store.dart';
import 'package:mobile/widgets/bottomBar/main_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/global_player.dart';
import 'package:mobile/util/bottom_index.dart';
import 'package:mobile/util/calendar_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.get("PROJECT_URL"), anonKey: dotenv.get("PROJECT_API_KEY"));

  MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalAudioPlayer()),
        ChangeNotifierProvider(create: (context) => BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => BottomIndex()),
        ChangeNotifierProvider(create: (context) => ScheduleColorProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleEventsProvider()),
        ChangeNotifierProvider(create: (context) => ModifyingScheduleProvider()),
        // ChangeNotifierProvider(create: (context) => ClassBottomIndex()),
        ChangeNotifierProvider(
            create: (context) => BackgroundSettingProvider()),
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
  final List screens = [MyRoom(), Mate(), Store(), LoginPage()];

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
