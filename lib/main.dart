import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/view_model/common/bottom_bar_view_model.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'style.dart' as mainstyle;
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.get("PROJECT_URL"), anonKey: dotenv.get("PROJECT_API_KEY"));

  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> with WidgetsBindingObserver{
  final BottomBarViewModel bottomBarViewModel = Get.put(BottomBarViewModel());
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));


  @override
  void initState() {
    super.initState();
    viewModel.initAllSchedules();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: BLACK, // 하단 시스템UI 검정색
    ));
    return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: mainstyle.theme,
      home: Obx(() => Scaffold(
        // appBar: AppBar(),
        body: bottomBarViewModel.setScreen(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomBarViewModel.bottomIndex,
            onTap: bottomBarViewModel.setBottomIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: '홈'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.time), label: '일 정'),
              BottomNavigationBarItem(icon: Icon(Icons.person_3), label: '메이트'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.login), label: '로그인(임시)'),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: '더보기'),
            ]),
      ))
    );
      // appBar: AppBar(),
  }
}
