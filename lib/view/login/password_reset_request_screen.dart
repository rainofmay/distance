import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordResetScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  PasswordResetScreen({super.key});

  Future<void> resetPassword(String email) async {
    try {
      // Supabase 비밀번호 초기화 로직
      await Supabase.instance.client.auth.resetPasswordForEmail(email, redirectTo: 'distance://resetPassword'
      );
      // 성공 메시지 스낵바
      Get.snackbar(
        '성공',
        '비밀번호 초기화 이메일이 전송되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (error) {
      // 오류 메시지 스낵바
      Get.snackbar(
        '오류',
        '비밀번호 초기화 중 오류 발생: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 초기화')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('비밀번호 초기화 요청'),
              onPressed: () => resetPassword(_emailController.text),
            ),
          ],
        ),
      ),
    );
  }
}