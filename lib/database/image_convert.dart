import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

 String? imageBase64;
 Uint8List? bytes;
Widget getImagenBase64(String imagen) {
  imageBase64 = imagen;
  const Base64Codec base64 = Base64Codec();
  if (imageBase64 == null) return Container();
  bytes = base64.decode(imageBase64!);
  return Image.memory(
    bytes!,
    width: 200,
    fit: BoxFit.fitWidth,
  );
}