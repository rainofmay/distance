import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  // 이메일 형식이 올바른지 확인
                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(input)) {
                    return '올바른 이메일 형식이 아닙니다';
                  }
                  return null;
                },
                onSaved: (input) => _email = input!,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              TextFormField(
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  // 비밀번호가 6자 이상인지 확인
                  if (input.length < 6) {
                    return '비밀번호는 최소 6자 이상이어야 합니다';
                  }
                  return null;
                },
                onSaved: (input) => _password = input!,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: signUp,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        _showDialog('회원가입 성공', '회원가입에 성공했습니다.');

        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

      } catch (e) {
        _showDialog('회원가입 실패', '회원가입에 실패했습니다. 다시 시도해주세요.');
        print(e);
      }
    }
  }

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
