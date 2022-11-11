import 'package:firebase_storage/firebase_storage.dart';

class Url {
  var image;

  Url({required this.image});
}

Future<Url> imageurl(var image) async {
  var url;

  try {
    url = await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  } catch (e) {}

  return Url(image: url);
}
