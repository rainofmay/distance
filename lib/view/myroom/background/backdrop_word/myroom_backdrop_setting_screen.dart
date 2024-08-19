import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/custom_alert_dialog.dart';
import 'package:mobile/widgets/glass_morphism.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';

class QuoteSettingsDialog extends StatelessWidget {
  final MyroomViewModel viewModel = Get.find<MyroomViewModel>();

  QuoteSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GlassMorphism(
            blur: 1,
            opacity: 0.65,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Words of the day',
                      style: TextStyle(fontSize: 18, color: WHITE),
                    ),
                    Expanded(
                      child: Obx(() => ListView(
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: 16),
                              _buildBackdropColorPicker(context),
                              const SizedBox(height: 16),
                              _buildFontColorPicker(context),
                              const SizedBox(height: 16),
                              _buildFontDropdown(context),
                              const SizedBox(height: 16),
                              _buildCustomQuoteFields(),
                              const SizedBox(height: 16),
                              _buildFontSizeSlider(),
                            ],
                          )),
                    ),
                    OkCancelButtons(
                      cancelText: '닫기',
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      onPressed: () {
                        Navigator.pop(context);
                        if (viewModel.isBackdropWordEnabled == false) {
                          _optionDialog(context);
                        }
                      },
                      okText: '보이기',
                      okTextColor: PRIMARY_LIGHT,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackdropColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('배경 색상', style: TextStyle(color: WHITE)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showColorPicker(context, isBackdrop: true),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: viewModel.quoteBackdropColor.value,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('폰트 색상', style: TextStyle(color: WHITE)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showColorPicker(context, isBackdrop: false),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: viewModel.quoteFontColor.value,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('폰트 지정', style: TextStyle(color: WHITE)),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: BLACK,
          ),
          child: DropdownButton<String>(
            value: viewModel.quoteFont.value,
            style: TextStyle(color: WHITE),
            items: [
              'Cafe24OhsquareAir',
              'Cafe24SupermagicRegular',
              'CormorantGaramondMedium',
              'EduAUVICWANTHandRegular',
              'GaeguRegular',
              'GmarketSansTTFLight',
              'GmarketSansTTFMedium',
              'NotoSansKRBold',
              'NotoSansKRLight',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) viewModel.updateQuoteFont(newValue);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomQuoteFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Words of the day', style: TextStyle(color: WHITE)),
        Obx(() => TextFormField(
              // controller: viewModel.wordsController,
              initialValue: viewModel.currentQuote.quote,
              style: TextStyle(color: WHITE, fontSize: 12),
              cursorColor: PRIMARY_LIGHT,
              decoration: InputDecoration(
                hintText: '보이고 싶은 말을 적어보세요.',
                hintStyle: const TextStyle(color: TRANSPARENT_WHITE, fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: PRIMARY_LIGHT), // 활성 상태일 때의 밑줄 색상
                ),
              ),
              onChanged: (value) {
                viewModel.updateCustomQuote(value);
              },
              autocorrect: false,
              // 자동 수정 비활성화
              enableSuggestions: false, // 추천 단어 기능 비활성화
            )),
        SizedBox(height: 8),
        Text('Who', style: const TextStyle(color: WHITE)),
        Obx(() => TextFormField(
              // controller: viewModel.writerController,
              initialValue: viewModel.currentQuote.writer,
              style: const TextStyle(color: WHITE, fontSize: 12),
              decoration: InputDecoration(
                hintText: '누구의 말인가요?',
                hintStyle: const TextStyle(color: TRANSPARENT_WHITE, fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: PRIMARY_LIGHT), // 활성 상태일 때의 밑줄 색상
                ),
              ),
              onChanged: (value) => viewModel.updateCustomQuoteAuthor(value),
              autocorrect: false,
              // 자동 수정 비활성화
              enableSuggestions: false, // 추천 단어 기능 비활성화
            )),
      ],
    );
  }

  Widget _buildFontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('폰트 크기', style: TextStyle(color: WHITE)),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: PRIMARY_LIGHT,
            inactiveTrackColor: WHITE.withOpacity(0.5),
            thumbColor: WHITE,
            overlayColor: PRIMARY_LIGHT.withOpacity(0.4),
            valueIndicatorColor: PRIMARY_LIGHT,
            valueIndicatorTextStyle: TextStyle(color: Colors.black),
          ),
          child: Slider(
            value: viewModel.quoteFontSize.value,
            min: 12.0,
            max: 32.0,
            onChanged: (value) => viewModel.updateQuoteFontSize(value),
          ),
        ),
      ],
    );
  }
  void _optionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: '설정',
            width: 120,
            height: 30,
            contents: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Text('설정하신 문구를 화면에 띄울까요?',
                  style: TextStyle(color: WHITE)),
            ),
            actionWidget: OkCancelButtons(
                okText: '확인',
                okTextColor: PRIMARY_LIGHT,
                cancelText: '취소',
                onPressed: () {
                  viewModel.updateBackdropWordChange(
                      !viewModel
                          .isBackdropWordEnabled);
                  Navigator.of(context).pop();
                },
              onCancelPressed: () {
                Navigator.of(context).pop();
              }
            ));
      },
    );
  }
  void _showColorPicker(BuildContext context, {required bool isBackdrop}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(isBackdrop ? 'Pick backdrop color' : 'Pick font color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isBackdrop
                  ? viewModel.quoteBackdropColor.value
                  : viewModel.quoteFontColor.value,
              onColorChanged: (Color color) {
                if (isBackdrop) {
                  viewModel.updateQuoteBackdropColor(color);
                } else {
                  viewModel.updateQuoteFontColor(color);
                }
              },
              enableAlpha: true,
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            OkCancelButtons(
                okText: '확인',
                okTextColor: BLACK,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }
}
