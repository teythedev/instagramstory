// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory/controllers/story_group_main_controller.dart';

import 'package:video_player/video_player.dart';

import '../models/story.dart';

class StoryGroupCardController extends GetxController {
  var currentStoryIndex = 0.obs;

  List<Story> strs;
  TickerProvider vsync;
  var stories = <Story>[].obs;
  StoryGroupCardController({
    required this.strs,
    required this.vsync,
  }) {
    stories.value = strs;
  }
  VideoPlayerController? get currentVideoPlayerController =>
      videoControllers[currentStoryIndex.value];
  var videoControllers = <int, VideoPlayerController>{}.obs;
  var progressBarControllers = <int, AnimationController>{}.obs;
  AnimationController? get currentProgressBarController =>
      progressBarControllers[currentStoryIndex.value];

  Story get currentStory => stories[currentStoryIndex.value];
  @override
  void onInit() {
    for (var i = 0; i < stories.length; i++) {
      final str = stories[i];
      if (str.mediaType == VideoOrImage.VIDEO) {
        videoControllers[i] = VideoPlayerController.network(str.url)
          ..initialize();
      }
      progressBarControllers[i] = AnimationController(
        vsync: vsync,
        duration: Duration(
          seconds: str.duration,
        ),
      );
    }

    super.onInit();
  }

  @override
  void onClose() {
    for (var vcntrl in videoControllers.values) {
      vcntrl.dispose();
    }
    for (var acntrl in progressBarControllers.values) {
      acntrl.dispose();
    }
    super.onClose();
  }

  nextStoryIndex() {
    if (currentStoryIndex.value < stories.length - 1) {
      endVideo();
      currentStoryIndex.value += 1;
      playVideo();
    } else {
      endVideo();
      moveNextGroup();
    }
  }

  moveNextGroup() {
    final mainController = Get.find<StoryGroupMainController>();
    mainController.nextGroup();
  }

  previousIndex() {
    resetVideo();
    if (currentStoryIndex.value == 0) {
      playVideo();
    } else {
      currentStoryIndex.value -= 1;
      resetVideo();
      playVideo();
    }
  }

  replayVideo() {
    final contr = videoControllers[currentStoryIndex.value];
    final prg = progressBarControllers[currentStoryIndex.value];
    if (contr != null) {
      contr.seekTo(Duration.zero);
      contr.pause();
    }
    if (prg != null) {
      prg.reset();
    }
    //playVideo();
  }

  resetVideo() {
    final contr = videoControllers[currentStoryIndex.value];
    final prg = progressBarControllers[currentStoryIndex.value];
    if (contr != null) {
      contr.seekTo(Duration.zero);
    }
    if (prg != null) {
      prg.reset();
    }
  }

  endVideo() {
    final contr = videoControllers[currentStoryIndex.value];
    final prg = progressBarControllers[currentStoryIndex.value];
    if (contr != null) {
      contr.seekTo(contr.value.duration);
    }
    if (prg != null) {
      prg.forward(from: currentStory.duration.toDouble());
    }
  }

  pauseVideo() {
    final contr = videoControllers[currentStoryIndex.value];
    final prg = progressBarControllers[currentStoryIndex.value];
    if (contr != null) {
      contr.pause();

      if (prg != null) {
        prg.stop();
      }
    } else {
      if (prg != null) {
        prg.stop();
      }
    }
  }

  playVideo() {
    final str = stories[currentStoryIndex.value].duration;
    final contr = videoControllers[currentStoryIndex.value];
    final prg = progressBarControllers[currentStoryIndex.value];

    if (contr != null) {
      if (contr.value.isInitialized) {
        if (prg != null) {
          contr.play();
          prg.duration = Duration(seconds: contr.value.duration.inSeconds);
          prg.forward().whenComplete(() {
            nextStoryIndex();
          });
        }
      } else {
        contr.initialize().then((value) {
          if (prg != null) {
            contr.play();
            prg.duration = Duration(seconds: contr.value.duration.inSeconds);
            prg.forward().whenComplete(() {
              nextStoryIndex();
            });
          }
        });
      }
    } else {
      if (prg != null) {
        prg.duration = Duration(seconds: str);
        prg.forward().whenComplete(() {
          if (currentStoryIndex.value < stories.length - 1) {
            nextStoryIndex();
          } else {
            final mainController = Get.find<StoryGroupMainController>();
            if (mainController.currentStoryGroupIndex.value <
                mainController.groupControllers.length - 1) {
              nextStoryIndex();
            }
          }
        });
      }
    }
  }
}
