import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

Future<void> showDeleteDialog(BuildContext context, File file, {bool photo = true}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete File?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this file?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red),),
            onPressed: () {
              file.deleteSync();
              Navigator.pop(context);
              showToast('File Deleted');
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
