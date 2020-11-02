import 'package:flutter/material.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/ui/common/load_media.dart';

class SavedPhotos extends StatefulWidget {

  @override
  _SavedPhotosState createState() => _SavedPhotosState();
}

class _SavedPhotosState extends State<SavedPhotos> {
  MediaType mediaType = MediaType.photo;
  @override
  Widget build(BuildContext context) {

    return LoadMedia(mediaType: mediaType, saved: true,);
  }
}
