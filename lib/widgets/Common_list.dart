import 'package:flutter/material.dart';
import 'package:abhedeye_dermacare_01/providers/common_list_provider.dart';
class Common_list extends StatelessWidget {

  late String ky ;
  late bool multi_select;

 Future<Common_list_Provider> create({required List<String> list}) async {

   return Common_list_Provider(l: list );

 }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
