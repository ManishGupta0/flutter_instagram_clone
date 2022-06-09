import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadImage(
    String folder,
    Uint8List file,
  ) async {
    var uploadTask = _storage
        .ref()
        .child(folder)
        .child(_auth.currentUser!.uid)
        .putData(file);

    var snapshot = await uploadTask;
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<bool> deleteImage(String url) async {
    await _storage.refFromURL(url).delete();
    return true;
  }
}
