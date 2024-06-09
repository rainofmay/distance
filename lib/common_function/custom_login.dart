import 'package:flutter/material.dart';

inputEmailValidator(value) {
  if (value == null || value.isEmpty) {
    return '이메일을 입력하세요';
  }
  // 이메일 형식이 올바른지 확인
  if (!RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
      .hasMatch(value)) {
    return '올바른 이메일 형식이 아닙니다';
  }
  return null;
}

inputPasswordValidator(value) {
  if (value == null || value.isEmpty) {
    return '비밀번호를 입력하세요';
  }
  // 비밀번호가 6자 이상인지 확인
  if (value.length < 6) {
    return '비밀번호는 최소 6자 이상이어야 합니다';
  }
  return null;
}

inputPasswordReValidator(value) {
  if (value == null || value.isEmpty) {
    return '비밀번호 확인을 입력하세요';
  }
  // 비밀번호가 일치하는지 확인하는 로직
  // if (value.length < 6) {
  //   return '비밀번호는 최소 6자 이상이어야 합니다';
  // }
  return null;
}