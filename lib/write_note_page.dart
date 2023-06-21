import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/draw_page.dart';
import 'package:notes/home_page.dart';
import 'package:notes/voice_recorder_page.dart';
import 'package:notes/camera/access_galery.dart';
import 'package:notes/camera/camera_page.dart';
import 'database/note_dao.dart';

DateTime dateTime = DateTime.now();

class WriteNotePage extends StatefulWidget {
  const WriteNotePage({super.key});

  @override
  State<WriteNotePage> createState() => _WriteNotePageState();
}

class _WriteNotePageState extends State<WriteNotePage> {
  bool bottomSheetVisible = false;
  var title = TextEditingController();
  var note = TextEditingController();
  String date = "${dateTime.month}/${dateTime.day}, ${dateTime.hour}:${dateTime.minute}";

  Future<void> saveNote(String title, String text, String date) async {
    await NotesDao().addNote(title, text, date).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        )));
    print(" $title - $text saved");
  }

  @override
  Widget build(BuildContext context) {
    bottomSheetVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleTextField(title: title),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NoteTextField(note: note),
              ),
            ],
          ),
        ),
        bottomSheet: Visibility(
          visible: bottomSheetVisible,
          child: const SizedBox(
            child: PageBottomNavigationBar(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Save",
          onPressed: () => saveNote(
            title.text,
            note.text,
            date,
          ),
          child: const Icon(
            Icons.save,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop);
  }
}

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    super.key,
    required this.title,
  });

  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: title,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: "title".tr(),
        ));
  }
}

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key,
    required this.note,
  });

  final TextEditingController note;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 50,
      controller: note,
      autofocus: true,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "startTyping".tr(),
      ),
    );
  }
}

class PageBottomNavigationBar extends StatelessWidget {
  const PageBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 28,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: Colors.deepOrangeAccent,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.deepOrangeAccent,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.draw,
              color: Colors.deepOrangeAccent,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.keyboard_voice,
              color: Colors.deepOrangeAccent,
            ),
            label: ""),
      ],
      currentIndex: 0,
      onTap: (value) async {
        if (value == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GalleryAccess(),
              ));
        }
        if (value == 1) {
          await availableCameras().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraPage(
                        cameras: value,
                      ))));
        }
        if (value == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DrawingPage(),
              ));
        }
        if (value == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VoiceRecorderPage(),
              ));
        }
      },
    );
  }
}
