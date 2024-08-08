import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/schedule/schedule_provider.dart';
import 'package:mobile/repository/schedule/schedule_repository.dart';
import 'package:mobile/util/mate/online_status_manager.dart';
import 'package:mobile/util/notification_service.dart';
import 'package:mobile/view_model/common/bottom_bar_view_model.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'style.dart' as mainstyle;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<InitializationStatus> _initGoogleMobileAds() {
  // TODO: Initialize Google Mobile Ads SDK
  return MobileAds.instance.initialize();
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //플러터 프레임워크가 준비될 때까지 대기
  //await OnlineStatusManager.initializeBackgroundFetch();
  await initializeDateFormatting();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.get("PROJECT_URL"), anonKey: dotenv.get("PROJECT_API_KEY"));
  KakaoSdk.init(nativeAppKey: 'aec099113dc70792df78c1aa4a1ac2f4');
  _initGoogleMobileAds();

  runApp(const MainPage());
  FlutterNativeSplash.remove();
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> with WidgetsBindingObserver {
  final BottomBarViewModel bottomBarViewModel = Get.put(BottomBarViewModel());
  final ScheduleViewModel viewModel = Get.put(ScheduleViewModel(
      repository: Get.put(
          ScheduleRepository(scheduleProvider: Get.put(ScheduleProvider())))));
  final MyroomViewModel myRoomViewModel = Get.put(MyroomViewModel());
  final notificationService = NotificationService();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    myRoomViewModel.loadPreferences(); // Load preferences here
    notificationService.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                  onTap: (index) {
                    bottomBarViewModel.setBottomIndex(index);
                  },
                  items: [
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded), label: '홈'),
                    const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.time), label: '일 정'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.person_3), label: '메이트'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.more_horiz_rounded), label: '더보기'),
                  ]),
            )));
  }
}
