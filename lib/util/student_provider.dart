import 'package:flutter/material.dart';

class StudentProvider with ChangeNotifier {
  Student _student = Student(
    name: '',
    age: 0,
    gender: '',
    dateOfBirth: DateTime.now(),
    schoolName: '',
    grade: '',
    majorOrInterest: '',
    gradePointAverage: 0.0,
    extracurricularActivities: [],
    subjectGrades: {},
    studyMethods: [],
  );

  Student get student => _student;

  void setStudent(Student newStudent) {
    _student = newStudent;
    notifyListeners();
  }
}
class Student {
  String name;
  int age;
  String gender;
  DateTime dateOfBirth;
  String schoolName;
  String grade;
  String majorOrInterest;
  double gradePointAverage;
  List<String> extracurricularActivities;
  Map<String, double> subjectGrades;
  List<String> studyMethods;

  Student({
    required this.name,
    required this.age,
    required this.gender,
    required this.dateOfBirth,
    required this.schoolName,
    required this.grade,
    required this.majorOrInterest,
    required this.gradePointAverage,
    required this.extracurricularActivities,
    required this.subjectGrades,
    required this.studyMethods,
  });
}
