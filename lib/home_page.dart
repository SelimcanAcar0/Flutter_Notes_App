import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/notes_detail_page.dart';
import 'package:notes/Provider/view_class.dart';
import 'package:notes/write_note_page.dart';
import 'package:notes/database/note_dao.dart';
import 'package:notes/database/notes_class.dart';
import 'package:notes/Animation/navigator_animation.dart';
import 'package:provider/provider.dart';
import 'Provider/theme_provider.dart';

Future<List<Notes>> showAllNotes() async {
  var listNote = await NotesDao().allNotes();
  return listNote;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isEn = true;
  void changeLanguage() async {
    setState(() {
      isEn = !isEn;
      isEn ? context.setLocale(const Locale("en")) : context.setLocale(const Locale("tr"));
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: pageDrawer(),
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<viewClass>(
        builder: (context, value, child) {
          return value.getView() == true ? myGridView() : myListView(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(routeAnimaton(const WriteNotePage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Drawer pageDrawer() {
    return Drawer(
      shape: const Border(left: BorderSide(width: 1)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Consumer<ThemeProvider>(
              builder: (context, themeValue, child) {
                return ListTile(
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false).swapTheme();
                  },
                  visualDensity: VisualDensity.compact,
                  style: ListTileStyle.list,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                  ),
                  title: Text(themeValue.selectedTheme == themeValue.dark ? "darkTheme".tr() : "lightTheme".tr()),
                  leading: themeValue.selectedTheme == themeValue.light
                      ? const Icon(
                          Icons.sunny,
                          color: Colors.yellow,
                        )
                      : const Icon(
                          Icons.dark_mode,
                          color: Colors.grey,
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: languageListTile(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Consumer<viewClass>(builder: (context, value, child) {
              return switchViewListView(context);
            }),
          ),
        ],
      ),
    );
  }

  ListTile switchViewListView(BuildContext context) {
    return ListTile(
      onTap: () {
        Provider.of<viewClass>(context, listen: false).swapView();
      },
      style: ListTileStyle.list,
      visualDensity: VisualDensity.compact,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
        ),
      ),
      title: Consumer<viewClass>(
        builder: (context, value, child) {
          return Text(value.switchView == true ? "gridView".tr() : "listView".tr());
        },
      ),
      leading: Consumer<viewClass>(
        builder: (context, value, child) {
          return Icon(
            value.switchView == true ? Icons.square : Icons.list,
          );
        },
      ),
    );
  }

  ListTile languageListTile() {
    return ListTile(
      onTap: () {
        changeLanguage();
      },
      style: ListTileStyle.list,
      visualDensity: VisualDensity.compact,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 1),
      ),
      title: Text("language".tr()),
      leading: Text(
        "lang".tr(),
        style: const TextStyle(
          color: Colors.orange,
        ),
      ),
    );
  }
}

Widget myGridView() {
  return FutureBuilder<List<Notes>>(
      future: showAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var notesList = snapshot.data;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: notesList!.length,
            itemBuilder: (context, index) {
              var notes = notesList[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotesDetailPage(notes: notes),
                        ));
                  },
                  child: Card(
                    shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: notes.title.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      notes.title,
                                      style: const TextStyle(color: Colors.redAccent),
                                      maxLines: 1,
                                    ),
                                  )
                                : null),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                notes.text,
                                maxLines: 4,
                              ),
                            )),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            bottom: 8,
                          ),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                notes.date,
                                style: const TextStyle(fontSize: 13),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(routeAnimaton(const WriteNotePage())),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Card(
                shape: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      Text(
                        "addFirstNote".tr(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      });
}

Widget myListView(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return FutureBuilder<List<Notes>>(
      future: showAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var notesList = snapshot.data;
          return ListView.builder(
            itemCount: notesList!.length,
            itemBuilder: (context, index) {
              var notes = notesList[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotesDetailPage(notes: notes),
                        ));
                  },
                  child: Card(
                    shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 2, top: 6),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                notes.date,
                                style: const TextStyle(fontSize: 13),
                              )),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: notes.title.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      notes.title,
                                      style: const TextStyle(color: Colors.redAccent),
                                      maxLines: 1,
                                    ),
                                  )
                                : null),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                notes.text,
                                maxLines: 4,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(routeAnimaton(const WriteNotePage())),
            child: SizedBox(
              height: 100,
              width: screenWidth,
              child: Card(
                shape: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                      ),
                      Text(
                        "addFirstNote".tr(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      });
}
