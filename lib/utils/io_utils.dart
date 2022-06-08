import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class IOUtils {
  static Future<Uint8List?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }

    return null;
  }
}
