import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class Utils {
  static Future<File> compressImage(File imageToCompress) async {
    final path = await getTemporaryDirectory().then((value) => value.path);
    int random = Random().nextInt(1000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 512, height: 512);

    return new File('$path/img_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}