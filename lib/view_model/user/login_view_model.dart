import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/custom_snackbar.dart';

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

    if (!context.mounted) return;
    if (isLoginSuccess) {
      CustomSnackbar.show(title: 'Email 로그인', message: 'Email 계정으로 로그인 되었습니다.');
    } else {
      CustomSnackbar.showLoginError();
    }
  }

  Future<void> signInWithKakao() async {
    try {
      await _provider.signInWithKakao();
      update();
      update();
    } catch (e) {
      CustomSnackbar.showLoginError();
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await _provider.signInWithGoogle(context);
      update();

    } catch (e) {
      CustomSnackbar.showLoginError();
    }
  }

  Future<void> signOut(BuildContext context) async {
    final viewModel = Get.find<MateViewModel>();
    try {
      await _provider.signOut(context);
      viewModel.logout();
      update();
    } catch (e) {
      print('$e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}