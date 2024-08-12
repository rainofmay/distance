import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';

class LoginViewModel extends GetxController {
  final LoginProvider _provider;

  /* constructor */
  LoginViewModel({required LoginProvider provider})
      : _provider = provider;

  final formKey = GlobalKey<FormState>();
  late final Rx<TextEditingController> _emailController = TextEditingController().obs;
  TextEditingController get emailController => _emailController.value;
  late final Rx<TextEditingController> _passwordController = TextEditingController().obs;
  TextEditingController get passwordController => _passwordController.value;

  final Rx<bool> _isLoggedIn = AuthHelper.isLoggedIn().obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    _emailController.value.dispose();
    _passwordController.value.dispose();
    super.dispose();
  }


  Future<void> signIn(BuildContext context) async {
    String emailValue = _emailController.value.text;
    String passwordValue = _passwordController.value.text;

    if (!formKey.currentState!.validate()) {
      return;
    }

    bool isLoginSuccess = await _provider.loginWithEmail(emailValue, passwordValue);

    // if (!context.mounted) return;
    // if (!isLoginSuccess) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('로그인에 실패했습니다.'),
    //   ));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('로그인 되었습니다.'),
    //   ));
    // }
  }

  Future<void> signInWithKakao() async {
    try {
      await _provider.signInWithKakao();
      // Get.snackbar('성공', '카카오 로그인 되었습니다.');
      update();
      update();
    } catch (e) {
      Get.snackbar('오류', '카카오 로그인에 실패했습니다.');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await _provider.signInWithGoogle(context);
      // Get.snackbar('성공', '구글 로그인 되었습니다.');
      update();

    } catch (e) {
      Get.snackbar('오류', '구글 로그인에 실패했습니다.');
    }
  }

  Future<void> signOut(BuildContext context) async {
    final viewModel = Get.find<MateViewModel>();
    try {
      await _provider.signOut(context);
      viewModel.logout();
      update();
    } catch (e) {
      Get.snackbar('오류', '로그아웃에 실패했습니다.');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}