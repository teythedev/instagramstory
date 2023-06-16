import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory/views/story_card.dart';
import 'controllers/story_group_card_controller.dart';
import 'controllers/story_group_main_controller.dart';
import 'models/story.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Insta Story',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late StoryGroupCardController contr;
  late StoryGroupCardController contr2;
  late StoryGroupCardController contr3;
  late StoryGroupCardController contr4;

  late StoryGroupMainController mainController;
  @override
  void initState() {
    contr = Get.put(
        StoryGroupCardController(
          vsync: this,
          strs: [
            ImageStory(
              url: "https://picsum.photos/250?image=3",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=4",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=5",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            VideoStory(
                url:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
            ImageStory(
              url: "https://picsum.photos/250?image=9",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            VideoStory(
                url:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
          ],
        ),
        tag: "0");
    contr2 = Get.put(
        StoryGroupCardController(
          vsync: this,
          strs: [
            ImageStory(
              url: "https://picsum.photos/250?image=0",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            ImageStory(
              url: "https://picsum.photos/250?image=9",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=3",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=4",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=5",
            ),
          ],
        ),
        tag: "1");
    contr3 = Get.put(
        StoryGroupCardController(
          vsync: this,
          strs: [
            ImageStory(
              url: "https://picsum.photos/250?image=0",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            ImageStory(
              url: "https://picsum.photos/250?image=9",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=3",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=4",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=5",
            ),
          ],
        ),
        tag: "2");
    contr4 = Get.put(
        StoryGroupCardController(
          vsync: this,
          strs: [
            ImageStory(
              url: "https://picsum.photos/250?image=3",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=4",
            ),
            ImageStory(
              url: "https://picsum.photos/250?image=5",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            VideoStory(
                url:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
            ImageStory(
              url: "https://picsum.photos/250?image=9",
            ),
            VideoStory(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4'),
            VideoStory(
                url:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
          ],
        ),
        tag: "3");
    mainController = Get.put(
      StoryGroupMainController(
        groupControllers: [contr, contr2, contr3, contr4],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<StoryGroupMainController>();
    super.dispose();
  }

  var delta = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: mainController.pageController,
        itemCount: mainController.groupControllers.length,
        itemBuilder: (context, position) {
          final page = GestureDetector(
            onLongPressUp: () {
              mainController.currentStoryGroupController.playVideo();
            },
            onTapDown: (details) =>
                mainController.currentStoryGroupController.pauseVideo(),
            onTapUp: (details) {
              final location = details.globalPosition.dx;
              if (location > MediaQuery.of(context).size.width / 2) {
                mainController.next();
              } else {
                mainController.previous();
              }
            },
            child: StoryGroupCard(
              groupCardController: mainController.groupControllers[position],
            ),
          );
          return Obx(
            () => position == mainController.currentPageValue.value.floor()
                ? Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..setEntry(
                        3,
                        2,
                        0.001,
                      )
                      ..rotateY(
                        -(pi / 2.7) *
                            (position - mainController.currentPageValue.value),
                      ),
                    child: page,
                  )
                : Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(
                        3,
                        2,
                        0.001,
                      )
                      ..rotateY(
                        (pi / 2.7) *
                            (mainController.currentPageValue.value - position),
                      ),
                    child: page,
                  ),
          );
        },
      ),
    );
  }
}
