// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class Story {
  String url;

  VideoOrImage? _mediaType;
  int? _duration;
  Story({
    required this.url,
  });

  VideoOrImage get mediaType;
  int get duration;
  set duration(int seconds) {
    _duration;
  }
}

class ImageStory extends Story {
  ImageStory({required String url}) : super(url: url) {
    _mediaType = VideoOrImage.IMAGE;
    _duration = 5;
  }

  @override
  VideoOrImage get mediaType => _mediaType!;

  @override
  int get duration => _duration!;
}

class VideoStory extends Story {
  VideoStory({required String url}) : super(url: url) {
    _mediaType = VideoOrImage.VIDEO;
  }

  @override
  VideoOrImage get mediaType => _mediaType!;

  @override
  int get duration => _duration ?? 5;

  @override
  set duration(int duration) {
    _duration ??= duration;
  }
}

enum VideoOrImage {
  // ignore: constant_identifier_names
  VIDEO,
  // ignore: constant_identifier_names
  IMAGE,
}
