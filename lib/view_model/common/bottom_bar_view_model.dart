import 'package:get/get.dart';
import '../../view/etc/etc.dart';
import '../../view/login/auth_screen.dart';
import '../../view/mate/mate_list_screen.dart';
import '../../view/myroom/myroom_screen.dart';

class BottomBarViewModel extends GetxController {
  final List screens = [MyroomScreen(), Mate(), AuthScreen(), Etc()];
  late final RxInt _bottomIndex = 0.obs;
  int get bottomIndex => _bottomIndex.value;

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