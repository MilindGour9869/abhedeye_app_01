import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Local_Storage {
  static const String complaint = "Complaint";

  static const String medicine = "Medicine";
  static const String services = "Services";

  static const List<String> others_list = [complaint];

  static Future<bool> set_local_data(
      {required String key,
      List<String>? common_list,
      Map<String, Map<String, dynamic>>? med_serv}) async {
    final _prefs = await SharedPreferences.getInstance();

    if (common_list != null) {
      return await _prefs.setStringList(key, common_list);
    } else if (med_serv != null) {
      final str = jsonEncode(med_serv);
      return await _prefs.setString(key, str);
    } else
      return false;
  }

  static Future<dynamic> get_local_data(
      {required String key, required bool is_it_map}) async {
    final _prefs = await SharedPreferences.getInstance();

    if (is_it_map) {
      final str = await _prefs.getString(key);
      return await jsonDecode(str!);
    } else {
      return await _prefs.getStringList(key);
    }
  }

  static Future<bool> get_all_cloud_data() async {
    final others_inst = FirebaseFirestore.instance.collection('Others');

   try{
     if(await InternetConnectionChecker().hasConnection)
     {
       others_list.forEach((doc_id) {
         others_inst.doc(doc_id).get().then((document_snap) {
           if (document_snap.exists) {
             List<dynamic> list = document_snap.data()!.values.toList().first;
             List<String> list2 = list.map((e) => e.toString()).toList();
             set_local_data(key: doc_id, common_list: list2);
           }
         });
       });

       final med_inst = FirebaseFirestore.instance.collection(medicine);

       med_inst.get().then((query_snap) async {
         if (query_snap.size > 0) {
           Map<String, Map<String, dynamic>>? map = {};
           query_snap.docs.forEach((element) {
             if (element.data().isNotEmpty) {
               map[element.id] = element.data();
             }
           });

           set_local_data(key: medicine, med_serv: map);
         }
       });

       final ser_inst = FirebaseFirestore.instance.collection(services);

       ser_inst.get().then((query_snap) async {
         if (query_snap.size > 0) {
           Map<String, Map<String, dynamic>>? map = {};
           query_snap.docs.forEach((element) {
             if (element.data().isNotEmpty) {
               map[element.id] = element.data();
             }
           });
           set_local_data(key: services, med_serv: map);
         }
       });

       return  true;
     }
     else
       {
         return  false;
       }


   }
   catch(e)
    {
      return  false;
    }

  }
}
