import 'dart:io';

import 'package:aws_s3_api/s3-2006-03-01.dart' as AWS;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    hasPermission = await Permission.storage.isGranted;
  }

  if (hasPermission) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final credentials = AWS.AwsClientCredentials(accessKey: dotenv.get("AWS_S3_ACCESS_KEY"), secretKey: dotenv.get("AWS_S3_SECRET_KEY"));
      final s3 = AWS.S3(region: dotenv.get("AWS_S3_REGION"), credentials: credentials);

      try {
        final key = 'user-profile/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
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
    }
  } else {
    Get.snackbar("권한 설정", "이미지 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.");
  }
  return null;
}

