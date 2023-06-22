import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/write_note_page.dart';

class GalleryAccess extends StatefulWidget {
  const GalleryAccess({Key? key}) : super(key: key);

  @override
  State<GalleryAccess> createState() => _AccessGaleryState();
}

class _AccessGaleryState extends State<GalleryAccess> {
  @override
  void initState() {
    super.initState();
    getFromGallery();
  }

  File? imageFile;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return imageFile != null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                      height: screenHeight * 0.8,
                      width: screenWidth,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          shape: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WriteNotePage(),
                                ));
                          },
                          child: const Icon(Icons.save),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        : Container();
  }

  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1500, maxHeight: 1500, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
