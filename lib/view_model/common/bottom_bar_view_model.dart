import 'package:get/get.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/view/schedule/schedule_screen.dart';
import '../../view/etc/etc.dart';
import '../../view/login/auth_screen.dart';
import '../../view/mate/mate_list_screen.dart';
import '../../view/myroom/myroom_screen.dart';

class BottomBarViewModel extends GetxController {
  final List screens = [MyroomScreen(), ScheduleScreen(), Mate(), AuthScreen(), Etc()];
  late final RxInt _bottomIndex = 0.obs;
  int get bottomIndex => _bottomIndex.value;
  final MyroomViewModel myroomViewModel = MyroomViewModel();

  @override
  void onInit() {
    super.onInit();
  }

  setBottomIndex(int index) {
    _bottomIndex.value = index;
    print(bottomIndex);
  }

  setScreen() {
    return screens.elementAt(_bottomIndex.value);
  }
}