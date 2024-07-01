import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view/myroom/widget/custom_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mobile/view_model/mate/mate_view_model.dart';

class StatusManageSchedulling extends StatefulWidget {
  final MateViewModel viewModel = Get.put(MateViewModel()); // ViewModel 인스턴스 생성
  StatusManageSchedulling({super.key});

  final _controller = TextEditingController();
  final _emojiController = TextEditingController();
  final _scrollController = ScrollController();

  late bool _emojiShowing = false;

  @override
  _StatusManageSchedullingState createState() =>
      _StatusManageSchedullingState();
}

class _StatusManageSchedullingState extends State<StatusManageSchedulling> {
  @override
  void initState() {
    super.initState();
    widget._emojiController.addListener(_updateEmojiText);
  }

  @override
  void dispose() {
    widget._emojiController.removeListener(_updateEmojiText);
    super.dispose();
  }

  void _updateEmojiText() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(title: "사용자 상태 지정", children: [
      Column(
        children: [
          Container(
              height: 66.0,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => {
                        setState(() {
                          widget._emojiShowing = !widget._emojiShowing;
                        })
                      },
                      child: Text(
                        widget._emojiController.text.isNotEmpty
                            ? widget._emojiController.text
                            : '+',
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                          controller: widget._controller,
                          scrollController: widget._scrollController,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: '뭘 하고 있는지 적어봐요!',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                              left: 16.0,
                              bottom: 8.0,
                              top: 8.0,
                              right: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          )),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                        onPressed: () {
                          widget.viewModel.onTapCurrentActivity(widget._emojiController.text, widget._controller.text);
                          print(widget._emojiController.text);
                          print(widget._controller.text);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        )),
                  )
                ],
              )),
          Offstage(
            offstage: !widget._emojiShowing,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
    // Handle the selected emoji here
              setState(() {
                widget._emojiController.clear();
                widget._emojiController.text= emoji.emoji;
              });
              },

    textEditingController: widget._emojiController,
              scrollController: widget._scrollController,
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                swapCategoryAndBottomBar: false,
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
