import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/controller/user_controller.dart';

class HistoryTabController extends GetxController {
  final Stream<QuerySnapshot> transaksi =
  FirebaseFirestore.instance.collection('transaksi').snapshots();
  final UserController user = Get.find<UserController>();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getTransaksi() async {
    var data = await FirebaseFirestore.instance
        .collection("transaksi")
        .orderBy('waktu', descending: true)
        .where("pembeli.email", isEqualTo: user.email.value)
        .get();
    return data.docs;
  }

  Future<void> deleteHistoryOrder(String id) async {
    try {
      FirebaseFirestore.instance
          .collection('transaksi')
          .doc(id)
          .delete()
          .then((value) => Get.snackbar(
          'Info', 'Successfully deleted shopping history',
          backgroundColor: Colors.white))
          .catchError((error) => Get.snackbar(
          'Failed', 'Failed deleted shopping history',
          backgroundColor:  Colors.red, colorText: Colors.white));
    } catch (error) {
      Get.snackbar('Error', 'Gagal $error', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}