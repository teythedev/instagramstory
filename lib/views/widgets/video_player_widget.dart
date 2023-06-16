// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final Function(int) onDurationCalculated;

  final VideoPlayerController controller;
  const VideoPlayerWidget({
    Key? key,
    required this.onDurationCalculated,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height,
                child: VideoPlayer(controller),
              )
            : const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: Colors.white,
                  backgroundColor: Colors.grey,
                ),
              ),
      ),
    );
  }
}
