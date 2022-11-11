import 'package:firebase_storage/firebase_storage.dart';
Future<void> deleteImage(var image) async {
  print("Deleted "+image);
  try {
    await FirebaseStorage.instance.ref().child(image).delete();
  }
  catch (e) {

  }
}
