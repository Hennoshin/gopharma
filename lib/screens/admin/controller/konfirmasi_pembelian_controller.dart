import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KonfirmasiPembelianController extends GetxController{
  final Stream<QuerySnapshot> transaksi = FirebaseFirestore.instance.collection('transaksi').snapshots();
  CollectionReference dataTransaksi = FirebaseFirestore.instance.collection('transaksi');
  RxBool isLoading = false.obs;

  Future <List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTransaksi()async {
    var data = await FirebaseFirestore.instance.collection("transaksi").where("konfirmasi", isEqualTo: false).get();
    return data.docs;
  }

  void konfirmasiBarang(String id)async{
    isLoading.value = true;
    await dataTransaksi.doc(id).update({
      'konfirmasi' : true
    }).then((value) {
      isLoading.value = false;
      Get.defaultDialog(
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        title: 'Success',
        buttonColor: Colors.pinkAccent,
        confirmTextColor: Colors.white,
        middleText:
        "Payment has been confirmed",
        textConfirm: "Continue",
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    }).catchError((error){
      isLoading.value = false;
      Get.defaultDialog(
          barrierDismissible: false,
          backgroundColor: Colors.red,
          title: 'Gagal',
          middleText:
          "Payment failed to confirmed, error $error",
          textConfirm: "Understand",
          buttonColor: Colors.pinkAccent.shade400,
          confirmTextColor: Colors.white
      );
    });
    isLoading.value = false;
  }

}