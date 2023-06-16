// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory/controllers/story_group_card_controller.dart';

class StoryGroupMainController extends GetxController {
  var currentStoryGroupIndex = 0.obs;

  StoryGroupCardController get currentStoryGroupController =>
      rxGroupControllers[currentStoryGroupIndex.value];

  List<StoryGroupCardController> groupControllers;

  var rxGroupControllers = <StoryGroupCardController>[].obs;

  StoryGroupMainController({
    required this.groupControllers,
  }) {
    rxGroupControllers.value = groupControllers;
  }

  late PageController pageController;

  var currentPageValue = 0.0.obs;

  @override
  void onInit() {
    pageController = PageController();

    pageController.addListener(() {
      currentPageValue.value = pageController.page!;
      currentStoryGroupController.replayVideo();
      currentStoryGroupIndex.value = currentPageValue.value.floor();
      if (pageController.page! == currentStoryGroupIndex.value) {
        currentStoryGroupController.playVideo();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    currentStoryGroupController.playVideo();
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  nextGroup() {
    if (currentStoryGroupIndex.value < rxGroupControllers.length - 1) {
      pageController
          .animateToPage(currentStoryGroupIndex.value + 1,
              duration: const Duration(milliseconds: 300), curve: Curves.linear)
          .then((value) {
        currentStoryGroupController.playVideo();
      });
    }
  }

  next() {
    if (currentStoryGroupController.currentStoryIndex.value <
        currentStoryGroupController.stories.length - 1) {
      currentStoryGroupController.nextStoryIndex();
    } else {
      //currentStoryGroupController.nextStoryIndex();
      if (currentStoryGroupIndex < rxGroupControllers.length - 1) {
        currentStoryGroupIndex += 1;

        pageController
            .animateToPage(currentStoryGroupIndex.value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) => currentStoryGroupController.playVideo());
      }
    }
  }

  previous() {
    if (currentStoryGroupController.currentStoryIndex.value > 0) {
      currentStoryGroupController.previousIndex();
    } else {
      currentStoryGroupController.previousIndex();
      if (currentStoryGroupIndex > 0) {
        currentStoryGroupController.resetVideo();
        currentStoryGroupIndex -= 1;

        pageController
            .animateToPage(currentStoryGroupIndex.value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) {
          currentStoryGroupController.resetVideo();
          currentStoryGroupController.playVideo();
        });
      }
    }
  }
}
