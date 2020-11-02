// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/ui/photos/photos.dart';
import 'package:status_saver/ui/videos/videos.dart';

import 'core/view_models/media_model.dart';
import 'ui/saved_media/saved_media.dart';
import 'ui/splash_screen/splash_screen.dart';

void main() {
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => MyApp(),
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MediaModel>(
      create: (context) => MediaModel(),
      child: StyledToast(
        toastAnimation: StyledToastAnimation.slideFromLeft,
        curve: Curves.bounceInOut,
        locale: const Locale('en', 'US'),
        child: MaterialApp(
          // locale: DevicePreview.of(context).locale,
          // builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: 'Status Saver',
          theme: ThemeData(
            primaryColor: Colors.blueGrey[900],
            textTheme: GoogleFonts.ralewayTextTheme(
              Theme.of(context).textTheme,
            ),
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
        drawer: _buildDrawer(model),
        backgroundColor: Colors.blueGrey[900],
        body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 60,
              centerTitle: true,
              title: Text(widget.title, style: GoogleFonts.raleway(),),
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

  Widget _buildDrawer(model) {
    return Drawer(
        child: Container(
      color: Color(0xFF053D45),
      child: ListView(
        children: [
          DrawerHeader(
              child: Container(
            child: Center(child: Image.asset('assets/icon.png')),
          )),
          Divider(color: Colors.white30, thickness: 1),
          InkWell(
            child: ListTile(
                title: Text('WhatsApp Statuses',
                    style: TextStyle(color: Colors.white))),
            onTap: () {
              Navigator.pop(context);
              model.setPath('wa');
            },
          ),
          Divider(color: Colors.white60, thickness: 1),
          InkWell(
            child: ListTile(
                title: Text('Business WhatsApp Statuses',
                    style: TextStyle(color: Colors.white))),
            onTap: () {
              Navigator.pop(context);
              model.setPath('business');
            },
          ),
          Divider(color: Colors.white60, thickness: 1),
          InkWell(
            child: ListTile(
                title: Text('GBWhatsApp Statuses',
                    style: TextStyle(color: Colors.white))),
            onTap: () {
              Navigator.pop(context);
              model.setPath('gb');
            },
          ),
          Divider(color: Colors.white60, thickness: 1),
        ],
      ),
    ));
  }
}
