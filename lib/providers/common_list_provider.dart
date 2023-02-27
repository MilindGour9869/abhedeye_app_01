import 'package:flutter/material.dart';

class Common_list_Provider extends ChangeNotifier{

  late List<String> list;
  late Map<String,bool> list_map ;

  Common_list_Provider({required List<String> l})
  {
    this.list = l;
    list.forEach((val) {
      list_map[val] = false;
    });

  }

  void search({required String search})
  {
    list = list_map.keys.toList()
        .where((string) => string.toLowerCase().contains(search.toLowerCase()))
        .toList();

    if (list.isEmpty) {
      list = [];

    }
    notifyListeners();

  }

  void on_tap({required String ky})
  {
    this.list_map[ky] =  this.list_map[ky]!;
    notifyListeners();
  }

}