import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:share/share.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/core/view_models/media_model.dart';

class VideoPlayer extends StatefulWidget {
  final File file;
  final int index;
  final MediaClass mediaClass;

  const VideoPlayer(
      {Key key, this.file, this.index, this.mediaClass = MediaClass.status})
      : super(key: key);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController controller;
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.file);
    flickManager = FlickManager(
      videoPlayerController: controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _handleDrag(DragEndDetails details) {
      Navigator.pop(context);
    }

    var model = context.watch<MediaModel>();

    _shareFile() {
      String vidPath = model.videos[widget.index].path;
      Share.shareFiles([vidPath]);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: _handleDrag,
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: FlickPortraitControls(),
                    ),
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      controls: FlickLandscapeControls(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: widget.mediaClass == MediaClass.saved
          ? FloatingActionButton(
              backgroundColor: Colors.red[600],
              onPressed: () async =>
                  await model.deleteFile(context, widget.file),
              child: Icon(Icons.delete),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                backgroundColor: Colors.blueGrey[900],
                mini: true,
                heroTag: 'Share',
                child: Icon(
                  Icons.share,
                  size: 19,
                ),
                onPressed: _shareFile,
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                backgroundColor: Color(0xFF053D45),
                child: Icon(Icons.save, size: 28,),
                onPressed: () async {
                  await model.saveFile(model.videos[widget.index],
                      isimage: false);
                  showToast("File Saved");
                },
              )
            ]),
    );
  }
}
