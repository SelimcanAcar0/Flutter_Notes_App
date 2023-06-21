import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class viewClass extends ChangeNotifier{
  late bool switchView;
  late SharedPreferences prefs;

  viewClass(bool viewMode) {
    switchView = viewMode==true?true : false;
  }
  Future<void> swapView() async {
    prefs = await SharedPreferences.getInstance();

    if (switchView == false) {
      switchView=true;
      await prefs.setBool("switchView", false);
    } else {
      switchView=false;
      await prefs.setBool("switchView", true);
    }
    notifyListeners();
  }


  bool getView()=>switchView;

}