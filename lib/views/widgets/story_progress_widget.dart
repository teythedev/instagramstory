import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryProgressWidget extends StatelessWidget {
  final AnimationController controller;
  final double width;
  late Animation _animation;
  StoryProgressWidget({
    Key? key,
    required this.controller,
    required this.width,
  }) : super(key: key) {
    _animation = Tween<double>(begin: 0, end: width).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 200,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              height: MediaQuery.of(context).size.height / 200,
              width: _animation.value,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      ],
    );
  }
}
