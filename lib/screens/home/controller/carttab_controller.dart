import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList myBasket = [].obs;
  RxList<Map<String, dynamic>> listBarangs = <Map<String, dynamic>>[].obs;
  RxInt totalBarang = 0.obs;
  RxInt totalHarga = 0.obs;

  CollectionReference transaksi = FirebaseFirestore.instance.collection('transaksi');


  void totalBarangs(){
    totalBarang.value=0;
    for (var element in listBarangs) {
      totalBarang += element['jumlah'];
    }
  }

  void totalHargas(){
    print('calculated price');
    totalHarga.value=0;
    for (var element in listBarangs) {
      totalHarga += element['total_harga'];
    }

    totalHarga.refresh();
    listBarangs.refresh();
  }

  void addTransaction(Map<String, dynamic> data )async{

    try{
      await transaksi.add(data).then((value){
        Get.snackbar("Info", 'Purchase confirmation sent please make a cash payment',
            backgroundColor: Colors.white);
        listBarangs.clear();
      }).catchError((error){
        Get.snackbar("Error", 'Purchased confirmation failed to send, error $error"',
            colorText: Colors.white,
            backgroundColor: Colors.red);
      });
    }catch(e){
      Get.snackbar("Error", 'Purchase confirmation failed to send, error $e"',
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }

  }

}