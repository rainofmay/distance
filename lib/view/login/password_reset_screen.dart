import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordUpdateController extends GetxController {
  final newPassword = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;

  void updatePassword() async {
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('오류', '비밀번호가 일치하지 않습니다.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword.value),
      );

      if (response.user != null) {
        Get.snackbar('성공', '비밀번호가 성공적으로 업데이트되었습니다.',
            backgroundColor: Colors.green, colorText: Colors.white);
        // 여기에 성공 후 처리 로직 (예: 홈 화면으로 이동)
      }
    } catch (error) {
      Get.snackbar('오류', '비밀번호 업데이트 중 오류가 발생했습니다: $error',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

class PasswordResetScreen extends StatelessWidget {
  final controller = Get.put(PasswordUpdateController());

  PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('비밀번호 변경', style: TextStyle(color: Colors.amber[300])),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'DISTANCE',
                style: TextStyle(
                  color: Colors.amber[300],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildPasswordField('새 비밀번호', controller.newPassword),
              SizedBox(height: 20),
              _buildPasswordField('비밀번호 확인', controller.confirmPassword),
              SizedBox(height: 30),
              Obx(() => ElevatedButton(
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.amber[300])
                    : Text('비밀번호 업데이트'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide(color: Colors.amber[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.updatePassword,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, RxString bindValue) {
    return Obx(() => TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.amber[100]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(color: Colors.amber[300]),
      onChanged: (value) => bindValue.value = value,
    ));
  }
}