import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/ui/common/load_media.dart';
class Photos extends StatefulWidget {
  Photos({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {

    return LoadMedia();
  }
}


Photos photos = Photos();