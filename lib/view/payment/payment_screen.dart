import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: "프리미엄 멤버십 가입",
        isLeading: true,
        isCenterTitle: true,
        backgroundColor: Colors.white,
        contentColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            subscribeTitle(),
            SizedBox(height: 50),
            subscribeBenefits(),
            SizedBox(height: 50),
            priceNotice(),
            SizedBox(height: 50),
            Center(
              child: subscribeButton()
            ),
            SizedBox(height: 16), // Add some bottom margin
          ],
        ),
      ),
    );
  }
  Widget subscribeTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distance Premium 체험하기",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),Text(
              "제한 없이 원하는 사진과 영상으로 배경을 설정하세요!",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Spacer(), // Push the icon to the right
        Icon(
          Icons.waving_hand,
          size: 30,
          color: Colors.blue,
        ),
      ],
    );
  }
  Widget subscribeBenefits() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "구독 혜택",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          _buildBenefitItem("• 모든 영역에서 광고가 제거됩니다."),
          _buildBenefitItem("• 모든 사진과 배경을 설정할 수 있습니다."),
          _buildBenefitItem("• 음악을 셔플 모드를 사용해서 들을 수 있습니다."),
          _buildBenefitItem("• 더 다양한 아바타 캐릭터를 사용할 수 있습니다."),
        ],
      ),
    );
  }
  Widget priceNotice() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "프리미엄 멤버쉽 구매",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent),
              ),
              Text("최초 구독시 2개월간 무료 체험 가능",
                  style:
                  TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
          Spacer(),
          Text(
            "월 2900원",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }
  Widget subscribeButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement the 2-month free subscription logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding:
        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        textStyle: TextStyle(fontSize: 18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        '프리미엄 회원으로 업그레이드하기',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text),
    );
  }
}
