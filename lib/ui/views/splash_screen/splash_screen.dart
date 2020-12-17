import 'dart:async';

import 'package:flutter/material.dart';
import 'package:status_saver/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, _changeRoute);
  }

  _changeRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          title: 'Status Saver',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF053D45),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Column(
          children: [
            Image.asset('assets/icon.png', height: 130,), 
            Text('Status Saver', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 70),
          ],
        ),
      ])),
    );
  }
}
