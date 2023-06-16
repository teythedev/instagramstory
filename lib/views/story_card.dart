import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory/views/widgets/story_progress_widget.dart';
import 'package:instagramstory/views/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import '../controllers/story_group_card_controller.dart';
import '../models/story.dart';

class StoryGroupCard extends StatelessWidget {
  final StoryGroupCardController groupCardController;
  const StoryGroupCard({
    Key? key,
    required this.groupCardController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Obx(
          () => StoryCard(
            story: groupCardController
                .stories[groupCardController.currentStoryIndex.value],
            videoPlayerController: groupCardController
                .videoControllers[groupCardController.currentStoryIndex.value],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                groupCardController.stories.length,
                (index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoryProgressWidget(
                      controller:
                          groupCardController.progressBarControllers[index]!,
                      width: ((MediaQuery.of(context).size.width) -
                              8 * groupCardController.stories.length) /
                          groupCardController.stories.length,
                    ),
                    index != groupCardController.stories.length - 1
                        ? const SizedBox(
                            width: 6,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VideoPlayerController? videoPlayerController;
  const StoryCard({
    Key? key,
    required this.story,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return videoPlayerController == null
        ? SafeArea(
            child: Image.network(
              story.url,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          )
        : VideoPlayerWidget(
            controller: videoPlayerController!,
            onDurationCalculated: (durationInSeconds) {
              story.duration = durationInSeconds;
            },
          );
  }
}
