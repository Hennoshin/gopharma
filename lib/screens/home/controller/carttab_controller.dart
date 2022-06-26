import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  RxList myBasket = [].obs;
  RxList<Map<String, dynamic>> listBarangs = <Map<String, dynamic>>[].obs;
  RxInt totalBarang = 0.obs;
  RxInt totalHarga = 0.obs;

  CollectionReference transaksi = FirebaseFirestore.instance.collection('transaksi');

  final _admin = FirebaseFirestore.instance.collection("users");
  final _adminEmail = "admin1@gmail.com";
  final _bearerToken = "AAAA0pyoyMU:APA91bGtrTsJU8VEclS0Fhl5eol932SdsOnR3YugOa123wCDrCiOC3FkA3h4v7kyiszjOlRqLyEVbGOWihgNOmhIzkDOSnhtVMI0lbq7Qem8XpTbkXfPFrkPMMYDt4J8iR1ot1cRV6AD";


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

  void sendNotification(String buyerEmail) async {
    try {
      var adminData = await _admin.doc(_adminEmail).get();

      String token = (adminData.data() as Map<String, dynamic>)["token"];

      var notificationBody = {"to": token, "notification": {
          "title": "Purchase Needs Confirmation",
          "body": buyerEmail + " has made a purchase, confirm this purchase"
        }
      };

      Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Bearer " + _bearerToken};
      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

      var response = await http.post(url, headers: headers, body: jsonEncode(notificationBody));
      print(response.body);

    } catch (e) {
      Get.snackbar("Error", 'Failed to send notification, $e"',
        colorText: Colors.white,
        backgroundColor: Colors.red
      );
    }
  }

}