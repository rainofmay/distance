import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/pages/login_screen/register_screen.dart'; // 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    _showDialog('Google 로그인 성공', '구글 로그인에 성공했습니다.');
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
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
                onPressed: signIn,
                child: Text('로그인'),
              ),
              SizedBox(height: 10.0), // 버튼과 버튼 사이에 간격 추가
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('회원가입'),
              ),
              SizedBox(height: 10.0), // 버튼과 버튼 사이에 간격 추가
              ElevatedButton(
                onPressed: resetPasswordDialog,
                child: Text('비밀번호 재설정'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        _showDialog('로그인 성공', '로그인에 성공했습니다.');
      } catch (e) {
        _showDialog('로그인 실패', '로그인에 실패했습니다. 다시 시도해주세요.');
        print(e);
      }
    }
  }

  void resetPasswordDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 재설정'),
          content: TextFormField(
            decoration: InputDecoration(labelText: '이메일'),
            onChanged: (value) {
              email = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (email.isNotEmpty) {
                  resetPassword(email);
                  Navigator.of(context).pop();
                }
              },
              child: Text('보내기'),
            ),
          ],
        );
      },
    );
  }

  void resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showDialog('비밀번호 재설정 이메일 전송', '비밀번호 재설정 이메일을 전송했습니다. 이메일을 확인해주세요.');
    } catch (e) {
      _showDialog('비밀번호 재설정 실패', '비밀번호 재설정 이메일 전송에 실패했습니다. 다시 시도해주세요.');
      print(e);
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
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
