import 'dart:io';
import 'dart:typed_data';

import 'package:koe/common/util.dart';
import 'package:path_provider/path_provider.dart';


class Cache {
  static Future<Directory> getCacheDirectory() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = dir.path;

    print(path);

    var cacheDir = Directory("$path/cache");
    if (!cacheDir.existsSync()) cacheDir.createSync();

    return cacheDir;
  }

  static Future<Uint8List> getOrCreate (name, {createCallback}) async {
    var path = (await getCacheDirectory()).path;
    File file = new File('$path/cache/${generateMd5(name)}');
    if (!file.existsSync()) {
      file.createSync();
      if (createCallback != null)
        createCallback(file);
    }

    return await file.readAsBytes();
  }
}