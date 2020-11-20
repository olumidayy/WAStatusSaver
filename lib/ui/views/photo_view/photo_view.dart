import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:share/share.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/core/view_models/media_model.dart';

class PhotoView extends StatefulWidget {
  final File file;

  final int index;

  final MediaClass mediaClass;

  PhotoView(
      {Key key, this.file, this.index, this.mediaClass = MediaClass.status})
      : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  PageController _controller;
  List photo;

  @override
  Widget build(BuildContext context) {
    void _handleDrag(details) {
      Navigator.pop(context);
    }

    _controller = PageController(initialPage: widget.index);

    var model = context.watch<MediaModel>();
    var photos = widget.mediaClass == MediaClass.status
        ? model.photos
        : model.savedPhotos;

    _shareFile() {
      String imgPath = photos[_controller.page.floor()].path;
      Share.shareFiles([imgPath]);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemBuilder: (context, position) {
            return Center(
              child: Hero(
                tag: photos[position].path,
                child: Container(
                  child: GestureDetector(
                    onVerticalDragEnd: _handleDrag,
                    child: Image.file(photos[position], fit: BoxFit.contain),
                  ),
                ),
              ),
            );
          },
          itemCount: photos.length,
        ),
      ),
      floatingActionButton: widget.mediaClass == MediaClass.saved
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                backgroundColor: Colors.red[600],
                onPressed: () async =>
                    await model.deleteFile(context, widget.file),
                child: Icon(Icons.delete),
              )
            ])
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
                child: Icon(
                  Icons.save,
                  size: 28,
                ),
                onPressed: () async {
                  await model.saveFile(photos[_controller.page.floor()]);
                  showToast("File Saved");
                },
              )
            ]),
    );
  }
}
