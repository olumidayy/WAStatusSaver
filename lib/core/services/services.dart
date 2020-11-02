import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class Services {
  Future<PermissionStatus> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    bool isGranted = await Permission.storage.isGranted;

    if (!isGranted) {
      status = await Permission.storage.request();
      if(status == PermissionStatus.granted)
        await createSaveDir();
      print(status);
    }
    return status;
  }

  Future<void> createSaveDir() async {
    var saveDir = Directory('/storage/emulated/0/WAStatusSaver');
    if(!saveDir.existsSync()){
      await new Directory('/storage/emulated/0/WAStatusSaver')
        .create(recursive: true);
    }
  }
}
