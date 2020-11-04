import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/ui/views/home/saved_media/saved_photos.dart';
import 'package:status_saver/ui/views/home/saved_media/saved_videos.dart';

class SavedMedia extends StatefulWidget {
  SavedMedia({Key key,}) : super(key: key);


  @override
  _SavedMediaState createState() => _SavedMediaState();
}

class _SavedMediaState extends State<SavedMedia> {
  List<Widget> _tabs = [ SavedPhotos(), SavedVideos() ];

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          appBar: TabBar(
            indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.photo_album_rounded)),
                Tab(icon: Icon(Icons.video_collection_rounded)),
              ],
            ),
          body: TabBarView(
            children: _tabs,
          ),
        ),
      );
  }
}


SavedMedia savedmedia = SavedMedia();