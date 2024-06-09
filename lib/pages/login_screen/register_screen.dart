import 'package:flutter/material.dart';
import 'package:mobile/pages/login_screen/login.dart';
import 'package:mobile/widgets/custom_text_form_field.dart';
import '../../common_function/custom_login.dart';
import '../../const/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double fieldWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextFormField(
                hintText: 'E-mail을 입력해 주세요.',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: false,
                isReadOnly: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailController,
                validator: (value) => inputEmailValidator(value),
              ),

              CustomTextFormField(
                hintText: '비밀번호를 입력해 주세요.',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: true,
                isReadOnly: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                validator: (value) => inputPasswordValidator(value),
              ),

              CustomTextFormField(
                hintText: '비밀번호 확인을 입력해 주세요.',
                maxLines: 1,
                fieldWidth: fieldWidth,
                isPasswordField: true,
                isReadOnly: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                controller: _passwordReController,
                validator: (value) => inputPasswordReValidator(value),
              ),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {}, //signUp,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void signUp() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     try {
  //       // await _auth.createUserWithEmailAndPassword(
  //       //   email: _email,
  //       //   password: _password,
  //       );
  //       _showDialog('회원가입 성공', '회원가입에 성공했습니다.');
  //
  //       if (!context.mounted) return;
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => LoginPage()),
  //       );
  //
  //     } catch (e) {
  //       _showDialog('회원가입 실패', '회원가입에 실패했습니다. 다시 시도해주세요.');
  //       print(e);
  //     }
  //   }
  // }

  void _showDialog(String title, String content) {
    showDialog(
      context: _formKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
