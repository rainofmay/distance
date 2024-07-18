import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/quotes.dart';
import 'package:mobile/model/quote_model.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
class MotivationalQuote extends StatelessWidget {
  final MyroomViewModel viewModel = Get.find<MyroomViewModel>();

  MotivationalQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final random = Random();
      final quote = viewModel.customQuote.value.isNotEmpty
          ? Quote(quote: viewModel.customQuote.value, writer: viewModel.customQuoteAuthor.value)
          : quotes[random.nextInt(quotes.length)];

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: viewModel.quoteBackdropColor.value,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quote.quote,
              style: TextStyle(
                color: viewModel.quoteFontColor.value,
                fontSize: viewModel.quoteFontSize.value,
                fontWeight: FontWeight.bold,
                fontFamily: viewModel.quoteFont.value,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "- ${quote.writer}",
              style: TextStyle(
                color: viewModel.quoteFontColor.value,
                fontSize: viewModel.quoteFontSize.value - 4,
                fontStyle: FontStyle.italic,
                fontFamily: viewModel.quoteFont.value,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      );
    });
  }
}