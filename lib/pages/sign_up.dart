import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/student_provider.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _majorOrInterestController =
  TextEditingController();
  final TextEditingController _gradePointAverageController =
  TextEditingController();
  final TextEditingController _extracurricularActivitiesController =
  TextEditingController();
  final TextEditingController _subjectGradesController =
  TextEditingController();
  final TextEditingController _studyMethodsController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '이름'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: '나이'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '나이를 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _genderController,
            decoration: InputDecoration(labelText: '성별'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '성별을 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dateOfBirthController,
            decoration: InputDecoration(labelText: '생년월일 (YYYY-MM-DD)'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '생년월일을 입력하세요';
              }
              // 생년월일 유효성 검사 로직 추가
              return null;
            },
          ),
          TextFormField(
            controller: _schoolNameController,
            decoration: InputDecoration(labelText: '학교/대학교 이름'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '학교/대학교 이름을 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _gradeController,
            decoration: InputDecoration(labelText: '학년/학년수'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '학년/학년수를 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _majorOrInterestController,
            decoration: InputDecoration(labelText: '전공 또는 관심 분야'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '전공 또는 관심 분야를 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _gradePointAverageController,
            decoration: InputDecoration(labelText: '학점 평균'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '학점 평균을 입력하세요';
              }
              // 학점 평균 유효성 검사 로직 추가
              return null;
            },
          ),
          TextFormField(
            controller: _extracurricularActivitiesController,
            decoration: InputDecoration(labelText: '교내/교외 활동'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '교내/교외 활동을 입력하세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _subjectGradesController,
            decoration: InputDecoration(labelText: '과목별 성적'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '과목별 성적을 입력하세요';
              }
              // 과목별 성적 유효성 검사 로직 추가
              return null;
            },
          ),
          TextFormField(
            controller: _studyMethodsController,
            decoration: InputDecoration(labelText: '학습 방법'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '학습 방법을 입력하세요';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // 폼 데이터를 Student 객체에 저장
                final studentProvider =
                Provider.of<StudentProvider>(context, listen: false);
                studentProvider.setStudent(
                  Student(
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                    gender: _genderController.text,
                    dateOfBirth: DateTime.parse(_dateOfBirthController.text),
                    schoolName: _schoolNameController.text,
                    grade: _gradeController.text,
                    majorOrInterest: _majorOrInterestController.text,
                    gradePointAverage:
                    double.parse(_gradePointAverageController.text),
                    extracurricularActivities: [
                      _extracurricularActivitiesController.text
                    ],
                    subjectGrades: {_subjectGradesController.text: 0.0},
                    studyMethods: [_studyMethodsController.text],
                  ),
                );
              }
            },
            child: Text('제출'),
          ),
        ],
      ),
    );
  }
}
