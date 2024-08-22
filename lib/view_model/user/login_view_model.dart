import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // CustomSnackbar.show(title: '로그아웃', message: '로그아웃 되었습니다.');
      update();
    } catch (e) {
      print('$e');
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      final currentUserId = await AuthHelper.getMyId();
      if (currentUserId == null) {
        throw Exception('사용자 ID를 가져올 수 없습니다.');
      }

      // Edge Function 호출
      final response = await Supabase.instance.client.functions.invoke(
        'deleteUser',
        body: {'userId': currentUserId},
      );

      // 로그아웃 처리
      await signOut(context);

      // 사용자 데이터 삭제
      await _provider.deleteAccount(context, currentUserId);

      // 성공 메시지 표시
      CustomSnackbar.show(title: '탈퇴', message: '계정이 성공적으로 삭제되었습니다.');

    } catch (e) {
      print('뷰모델 계정 삭제 중 오류 발생: $e');
      CustomSnackbar.show(title: '탈퇴 오류', message: '계정 삭제에 실패했습니다. 다시 시도해 주세요.');
    }
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}