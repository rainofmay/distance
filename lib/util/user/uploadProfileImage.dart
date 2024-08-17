import 'dart:io';

import 'package:aws_s3_api/s3-2006-03-01.dart' as AWS;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<void> requestPermissions(BuildContext context) async {
  if (Platform.isIOS) {
    var photosStatus = await Permission.photos.request();
    if (photosStatus.isPermanentlyDenied) {
      showPermissionDialog(context, "사진");
    }
  } else if (Platform.isAndroid) {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    if (storageStatus.isPermanentlyDenied) {
      showPermissionDialog(context, "저장소");
    }
  }
}

String sanitizeFileName(String fileName) {
// 파일 확장자 분리
  final parts = fileName.split('.');
  String name = parts.first;
  String extension = parts.length > 1 ? '.${parts.last}' : '';

// 특수 문자 제거 및 공백을 언더스코어로 대체
  name = name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');

// 현재 시간을 파일 이름에 추가하여 유니크성 보장
  String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

// 정규화된 파일 이름 생성
  return '${name}_$timestamp$extension'.toLowerCase();
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    return result == PermissionStatus.granted;
  }
}

void showPermissionDialog(BuildContext context, String permissionName) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('권한 필요'),
      content: Text('$permissionName 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('설정으로 이동'),
          onPressed: () {
            openAppSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<String?> uploadImage(BuildContext context) async {
  await requestPermissions(context);
  bool hasPermission = false;
  if (Platform.isIOS) {
    hasPermission = await Permission.photos.isGranted;
  } else if (Platform.isAndroid) {
    hasPermission = await Permission.photos.isGranted;
  }

  if (hasPermission) {
    final pickedFile = await _pickImage();
    if (pickedFile != null) {
      return await uploadToS3Profile(File(pickedFile.path));
    }
  } else {
    CustomSnackbar.show(
        title: '권한 설정', message: '이미지 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
    final permission = await _requestPermission(Permission.photos);
    debugPrint('permission : $permission');
  }
  return null;
}

Future<XFile?> _pickImage() async {
  final picker = ImagePicker();
  return await picker.pickImage(source: ImageSource.gallery);
}

Future<String?> uploadToS3Profile(File file) async {
  final credentials = AWS.AwsClientCredentials(
      accessKey: dotenv.get("AWS_S3_ACCESS_KEY"),
      secretKey: dotenv.get("AWS_S3_SECRET_KEY"));
  final s3 = AWS.S3(region: dotenv.get("AWS_S3_REGION"), credentials: credentials);

  try {
    final sanitizedFileName = sanitizeFileName(file.path.split('/').last);
    final key = 'user-profile/$sanitizedFileName';
    final response = await s3.putObject(
      bucket: dotenv.get("AWS_S3_BUCKET_NAME"),
      key: key,
      body: file.readAsBytesSync(),
    );

    if (response.eTag != null) {
      print('업로드 성공');
      // S3 객체의 URL 생성
      final url = 'https://${dotenv.get("AWS_S3_BUCKET_NAME")}.s3.${dotenv.get("AWS_S3_REGION")}.amazonaws.com/$key';
      return url;
    } else {
      print('업로드 실패: ${response.eTag}');
    }
  } catch (e) {
    print('오류 발생: $e');
  }
  return null;
}

Future<String?> uploadToS3CustomBackground(File file) async {
  final credentials = AWS.AwsClientCredentials(
      accessKey: dotenv.get("AWS_S3_ACCESS_KEY"),
      secretKey: dotenv.get("AWS_S3_SECRET_KEY"));
  final s3 = AWS.S3(region: dotenv.get("AWS_S3_REGION"), credentials: credentials);

  try {
    final sanitizedFileName = sanitizeFileName(file.path.split('/').last);
    final key = 'custom-background/$sanitizedFileName';
    final response = await s3.putObject(
      bucket: dotenv.get("AWS_S3_BUCKET_NAME"),
      key: key,
      body: file.readAsBytesSync(),
    );

    if (response.eTag != null) {
      print('업로드 성공');
      // S3 객체의 URL 생성
      final url = 'https://${dotenv.get("AWS_S3_BUCKET_NAME")}.s3.${dotenv.get("AWS_S3_REGION")}.amazonaws.com/$key';
      return url;
    } else {
      print('업로드 실패: ${response.eTag}');
    }
  } catch (e) {
    print('오류 발생: $e');
  }
  return null;
}
