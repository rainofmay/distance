import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/glass_morphism.dart';

class QuoteSettingsDialog extends StatelessWidget {
  final MyroomViewModel viewModel = Get.find<MyroomViewModel>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassMorphism(
        blur: 1,
        opacity: 0.65,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Quote Settings',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Obx(() => ListView(
                        children: [
                          _buildBackdropColorPicker(context),
                          _buildFontColorPicker(context),
                          _buildFontDropdown(context),
                          _buildFontSizeSlider(),
                        ],
                      )),
                ),
                _buildButtons(context),
              ],
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
        Text('Backdrop Color', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
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
        Text('Font Color', style: TextStyle(color: Colors.white)),
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
        Text('Font', style: TextStyle(color: Colors.white)),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black54,
          ),
          child: DropdownButton<String>(
            value: viewModel.quoteFont.value,
            style: TextStyle(color: Colors.white),
            items: [
              'GmarketSansTTFMedium',
              'Roboto',
              'Lato',
              'Open Sans',
              'Montserrat'
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

  Widget _buildFontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font Size', style: TextStyle(color: Colors.white)),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.5),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.4),
            valueIndicatorColor: Colors.white,
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

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            // 여기에 저장 로직 추가
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context, {required bool isBackdrop}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isBackdrop ? 'Pick backdrop color' : 'Pick font color'),
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
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
