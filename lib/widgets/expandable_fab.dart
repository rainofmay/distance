import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/action_buttons.dart';

class ExpandableFab extends StatefulWidget {
  //변하지 않는 값은 여기에
  final double distance; // Fab와 하위 Fab 간 거리
  final List<Widget> sub; // 새끼 위젯
  const ExpandableFab({super.key, required this.distance, required this.sub});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        value: isExpanded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        vsync: this);

    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack( // isExpanded ? buildTabToOpenFab() : buildTabToCloseFab();
        alignment: Alignment.bottomRight,
        children: [
          isExpanded ? buildTabToCloseFab() : buildTabToOpenFab(),
        ]..insertAll(0, buildExapndableActionButton()),
      ),
    );
  }

  List<ExpandableActionButton> buildExapndableActionButton () {
    List<ExpandableActionButton> animationSub = [];
    final int count = widget.sub.length;
    final double gap = 80.0 / (count);

    for (var i = 0, degree = 0.0; i < count; i++, degree += gap) {
      animationSub.add(ExpandableActionButton(
        distance: widget.distance,
        progress: _expandAnimation,
        baby: widget.sub[i],
        degree: degree,  //펼쳐질 때 각도
      ));
    }
    return animationSub;
  }

  AnimatedContainer buildTabToOpenFab() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
            onPressed: toggle,
            backgroundColor: DARK,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Icon(
            CupertinoIcons.cube,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildTabToCloseFab() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      child: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
            onPressed: toggle,
            backgroundColor: DARK,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Icon(
            CupertinoIcons.cube_fill,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }

  void toggle() {
    isExpanded = !isExpanded;
    setState(() {
      if (isExpanded)
        _controller.forward();
      else
        _controller.reverse();
    });
  }
}

class ExpandableActionButton extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget baby;

  const ExpandableActionButton({super.key,
    required this.distance,
    required this.degree,
    required this.baby,
    required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress,
        builder: (context, child) {
          final Offset offset = Offset.fromDirection(
              degree * (pi / 100), progress.value * distance);
          return Positioned(
              width: 35,
              height: 35,
              right: offset.dx+8.0,
              bottom: offset.dy+6.0,
              child: baby);
               // build(child)
        },
        child: baby);
  }
}
