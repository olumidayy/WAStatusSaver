import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/core/enums/enums.dart';
import 'package:status_saver/core/view_models/media_model.dart';
import 'package:status_saver/core/services/services.dart';
import 'package:status_saver/ui/views/photo_view/photo_view.dart';
import 'package:status_saver/ui/views/video_play/video_play.dart';


class LoadMedia extends StatefulWidget {
  LoadMedia({Key key, this.mediaType = MediaType.photo, this.saved = false})
      : super(key: key);

  final MediaType mediaType;
  final bool saved;

  @override
  _LoadMediaState createState() => _LoadMediaState();
}

class _LoadMediaState extends State<LoadMedia> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<MediaModel>();
    
  MediaClass mediaClass = widget.saved ? MediaClass.saved : MediaClass.status;

    return FutureBuilder(
      future: Services().checkStoragePermission(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == PermissionStatus.granted) {
            List<File> mediaList;
            if (widget.mediaType == MediaType.photo) {
              mediaList = widget.saved ? model.savedPhotos : model.photos;
            } else {
              mediaList = widget.saved ? model.savedVideos : model.videos;
            }

            return mediaList.isEmpty
                ? Center(
                    child: Text(
                      'Nothing to display yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : AnimationLimiter(
                    child: GridView.builder(
                    itemCount: mediaList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        columnCount: 2,
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SlideAnimation(
                            delay: Duration(milliseconds: 100),
                            verticalOffset: 70.0,
                            horizontalOffset: 50,
                            child: ScaleAnimation(
                              child: InkWell(
                                  child: Hero(
                                    child: widget.mediaType == MediaType.photo
                                        ? Container(
                                            child: Image.file(
                                            mediaList[index],
                                            fit: BoxFit.cover,
                                          ))
                                        : FutureBuilder(
                                            future: model.fetchVidThumbnail(
                                                mediaList[index].path),
                                            builder: (context, snapshot) {
                                              return !snapshot.hasData
                                                  ? Container()
                                                  : Container(
                                                      child: Container(
                                                        child: Center(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(40),
                                                                color: Colors.black.withOpacity(0.55)
                                                              ),
                                                              child: Icon(
                                                                  Icons
                                                                      .play_arrow_sharp,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: MemoryImage(
                                                                snapshot.data,
                                                              ))),
                                                    );
                                            }),
                                    tag: mediaList[index].path,
                                  ),
                                  onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          print(mediaList[index].path);
                                          return widget.mediaType ==
                                                  MediaType.photo
                                              ? PhotoView(
                                                  file: mediaList[index],
                                                  index: index,
                                                  mediaClass: mediaClass
                                                )
                                              : VideoPlayer(
                                                  file: mediaList[index],
                                                  index: index,
                                                  mediaClass: mediaClass,
                                                );
                                        }),
                                      )),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
          }
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Text(
                  'Give permission to access storage',
                  style: TextStyle(color: Colors.white),
                ),
                RaisedButton(
                  child: Text('Request'),
                  onPressed: () async =>
                      await Services().checkStoragePermission(),
                )
              ]));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
