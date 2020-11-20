import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/ui/views/home/photos/photos.dart';
import 'package:status_saver/ui/views/home/videos/videos.dart';
import 'package:status_saver/ui/widgets/widgets.dart';

import 'core/view_models/media_model.dart';
import 'ui/views/home/saved_media/saved_media.dart';
import 'ui/views/splash_screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MediaModel>(
      create: (context) => MediaModel(),
      child: StyledToast(
        toastAnimation: StyledToastAnimation.slideFromLeft,
        curve: Curves.bounceInOut,
        locale: const Locale('en', 'US'),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Status Saver',
          theme: ThemeData(
            primaryColor: Colors.blueGrey[900],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<Widget> _views = [photos, videos, savedmedia];

  _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<MediaModel>();
    return SafeArea(
      child: Scaffold(
        drawer: buildDrawer(model, context),
        backgroundColor: Colors.blueGrey[900],
        body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 60,
              centerTitle: true,
              title: Text(widget.title,),
              backgroundColor: Color(0xFF053D45),
              elevation: 3,
              floating: true,
            )
          ],
          body: _views[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          onTap: _setIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album_rounded), label: 'Photos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_collection_rounded), label: 'Videos'),
            BottomNavigationBarItem(icon: Icon(Icons.save_alt), label: 'Saved'),
          ],
          selectedItemColor: Colors.blueGrey[900],
        ),
      ),
    );
  }
}
