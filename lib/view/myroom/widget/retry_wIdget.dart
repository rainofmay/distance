import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RetryWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const RetryWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 40),
          SizedBox(height: 10),
          Text('이미지 로딩 실패', style: TextStyle(color: Colors.black54)),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('다시 시도'),
            onPressed: () {
              // 이미지 캐시를 지우고 다시 로드
              CachedNetworkImage.evictFromCache(url);
              // 위젯 트리를 다시 빌드하여 이미지 리로드
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
    );
  }
}