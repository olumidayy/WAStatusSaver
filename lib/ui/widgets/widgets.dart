import 'package:flutter/material.dart';

Drawer buildDrawer(model, context) {
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