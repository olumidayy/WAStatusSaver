import 'package:flutter/material.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/ui/common/load_media.dart';

class SavedVideos extends StatefulWidget {

  @override
  _SavedVideosState createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> {
  MediaType mediaType = MediaType.video;
  @override
  Widget build(BuildContext context) {

    return LoadMedia(mediaType: mediaType, saved: true);
  }
}
