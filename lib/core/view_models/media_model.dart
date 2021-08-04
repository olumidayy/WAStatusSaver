import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:status_saver/core/services/services.dart';
import 'package:status_saver/ui/common/delete_dialog.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:thumbnails/thumbnails.dart';

class MediaModel extends ChangeNotifier {
  static const statusFolder = 'WhatsApp';
  static const gbStatusFolder = 'GBWhatsApp';
  static const businessStatusFolder = 'WhatsApp Business';
  //'/storage/emulated/0/$statusFolder/Media/.Statuses'
  String _currentFolder = statusFolder;

  String get currentPath => _currentFolder;

  static const savePath = '/storage/emulated/0/WAStatusSaver';

  List<File> get photos => _fetchMedia();

  List<File> get videos => _fetchMedia(images: false);

  List<File> get savedPhotos => _fetchMedia(path: savePath);

  List<File> get savedVideos => _fetchMedia(path: savePath, images: false);

  setState() {
    notifyListeners();
  }

  void setPath(String arg) {
    switch (arg) {
      case 'gb':
        _currentFolder = gbStatusFolder;
        break;

      case 'business':
        _currentFolder = businessStatusFolder;
        break;

      case 'wa':
        _currentFolder = statusFolder;
        break;
      default:
        throw Error();
    }
    notifyListeners();
    print(_currentFolder);
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

  readFromPath(String path, {bool images = true}) {
    return Directory(path)
        .listSync()
        .where((item) => item.path.endsWith(images ? 'jpg' : 'mp4'))
        .map((e) => (e as File))
        .toList();
  }

  List<File> _fetchMedia({String path, bool images = true}) {
    List<String> paths = [
      '/storage/emulated/0/Android/media/com.whatsapp/$statusFolder/Media/.Statuses',
      '/storage/emulated/0/$statusFolder/Media/.Statuses'
    ];
    List<File> media = [];
    if (path != null) {
      media = readFromPath(path);
      print(readFromPath(path, images: false));
    } else {
      for (var p in paths) {
        try {
          media.addAll(readFromPath(p));
        } catch (e) {}
      }
    }
    if (media.isNotEmpty)
      media
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    print(media);
    // var vids = readFromPath('/storage/emulated/0/Android/media/com.whatsapp/$statusFolder/Media/.Statuses', images: false);
      // print(await fetchVidThumbnail(vids[0].path));
    media.removeLast();
    return media;
  }

  Future<Uint8List> fetchVidThumbnail(String path) async {
    var thumbnail;
    try {
        thumbnail = await Thumbnails.getThumbnail(
        thumbnailFolder: '/storage/emulated/0/Videos/Thumbnails',
        videoFile: path,
        imageType: ThumbFormat.PNG,
        quality: 30);
    } catch (e) { print(e); }
    return thumbnail;
  }

  Future<void> deleteFile(BuildContext context, File file) async {
    await showDeleteDialog(context, file);
    notifyListeners();
  }
}
