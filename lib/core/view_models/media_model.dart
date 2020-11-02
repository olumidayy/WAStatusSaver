import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:status_saver/core/services/services.dart';
import 'package:status_saver/ui/common/delete_dialog.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MediaModel extends ChangeNotifier {
  static const statusPath = '/storage/emulated/0/WhatsApp/Media/.Statuses';
  static const gbStatusPath = '/storage/emulated/0/GBWhatsApp/Media/.Statuses';
  static const businessStatusPath =
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses';

  String _currentPath = statusPath;

  String get currentPath => _currentPath;

  static const savePath = '/storage/emulated/0/WAStatusSaver';

  List<File> get photos => _fetchPhotos(_currentPath);

  List<File> get videos => _fetchVideos(_currentPath);

  List<File> get savedPhotos => _fetchPhotos(savePath);

  List<File> get savedVideos => _fetchVideos(savePath);

  void setPath(String arg) {
    switch (arg) {
      case 'gb':
        _currentPath = gbStatusPath;
        break;

      case 'business':
        _currentPath = businessStatusPath;
        break;

      case 'wa':
        _currentPath = statusPath;
        break;
      default:
        throw Error();
    }
    notifyListeners();
    print(_currentPath);
  }

  Future<void> saveFile(File file, {bool isimage = true}) async {
    var name = file.path.split('/').last.split('.')[0];
    Services().createSaveDir();
    try {
      if (isimage) {
        var imgBytes = await file.readAsBytes();
        ImageGallerySaver.saveImage(imgBytes,
            quality: 100, storePath: savePath, name: name);
      } else {
        ImageGallerySaver.saveFile(file.path, storePath: savePath, name: name);
      }

      print('successful');
    } catch (e) {
      print('error encountered');
    }
  }

  List<File> _fetchPhotos(String path) {
    List<File> photos;
    try {
      photos = Directory(path)
          .listSync()
          .where((item) => item.path.endsWith('jpg'))
          .map((e) => (e as File))
          .toList();
      photos
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    } catch (e) {
      print(e);
      photos = [];
    }

    return photos;
  }

  List<File> _fetchVideos(String path) {
    List<File> videos;
    try {
      videos = Directory(path)
          .listSync()
          .where((item) => item.path.endsWith('mp4'))
          .map((e) => (e as File))
          .toList();
      videos
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    } catch (e) {
      videos = [];
    }
    return videos;
  }

  Future<Uint8List> fetchVidThumbnail(String path) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 100,
    );
    return thumbnail;
  }

  Future<void> deleteFile(BuildContext context, File file) async {
    await showDeleteDialog(context, file);
    notifyListeners();
  }
}
