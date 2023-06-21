import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:notes/database/note_dao.dart';
import 'package:notes/home_page.dart';

import 'database/notes_class.dart';

class NotesDetailPage extends StatefulWidget {
  final Notes notes;

  const NotesDetailPage({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  State<NotesDetailPage> createState() => _NotesDetailPageState();
}

class _NotesDetailPageState extends State<NotesDetailPage> {
  bool bottomSheetVisible = false;
  var title = TextEditingController();
  var note = TextEditingController();
  String date = "";

  Future<void> delete(int id) async {
    await NotesDao().deleteNote(id).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
  }

  Future<void> update(int id, String title, String text, String date) async {
    await NotesDao()
        .updateNote(id, title, text, date)
        .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
  }

  @override
  void initState() {
    super.initState();
    var notes = widget.notes;
    title.text = notes.title;
    note.text = notes.text;
    date = notes.date;
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
                padding: const EdgeInsets.all(8),
                child: Text(date),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: titleTextField(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NoteTextField(note: note),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: deleteFAB(context),
            ),
            saveFAB(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        bottomSheet: Visibility(
          visible: bottomSheetVisible,
          child: const BottomSheetNavBar(),
        ));
  }

  TextField titleTextField() {
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
      ),
      onTap: () {
        setState(() {
          bottomSheetVisible = false;
        });
      },
    );
  }

  FloatingActionButton deleteFAB(BuildContext context) {
    return FloatingActionButton(
      heroTag: "deleteButton",
      backgroundColor: Colors.red,
      tooltip: "Delete",
      splashColor: Colors.deepOrange,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("ays".tr()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("no".tr()),
                  ),
                  TextButton(
                      onPressed: () {
                        delete(widget.notes.id);
                      },
                      child: Text("yes".tr()))
                ],
              );
            });
      },
      child: const Icon(
        Icons.delete,
      ),
    );
  }

  FloatingActionButton saveFAB() {
    return FloatingActionButton(
      heroTag: "saveButton",
      tooltip: "Save",
      splashColor: Colors.deepOrange,
      onPressed: () {
        widget.notes.title = title.text;
        widget.notes.text = note.text;
        widget.notes.date = date;
        setState(() {
          update(widget.notes.id, widget.notes.title, widget.notes.text, widget.notes.date);
        });
      },
      child: const Icon(
        Icons.save,
        color: Colors.black,
      ),
    );
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

class BottomSheetNavBar extends StatelessWidget {
  const BottomSheetNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: Colors.deepOrangeAccent,
            ),
            label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt, color: Colors.deepOrangeAccent), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.draw, color: Colors.deepOrangeAccent), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.keyboard_voice, color: Colors.deepOrangeAccent), label: ""),
      ],
    );
  }
}
