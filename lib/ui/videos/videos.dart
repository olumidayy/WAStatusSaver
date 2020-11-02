import 'package:flutter/material.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/ui/common/load_media.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  MediaType mediaType = MediaType.video;
  @override
  Widget build(BuildContext context) {
    return LoadMedia(
      mediaType: mediaType,
    );
  }
}

Videos videos = Videos();
