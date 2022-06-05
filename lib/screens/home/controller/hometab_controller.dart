import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gopharma/model/model_barang.dart';
import 'package:gopharma/screens/home/controller/carttab_controller.dart';

class HomeTabController extends GetxController {
  CartController cart = Get.find<CartController>();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamBarang() {
    return FirebaseFirestore.instance.collection('barangs').snapshots();
  }

  Future<String?> downloadUrlImage(String img) async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(img)
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getImage(String img) async {
    final link = await downloadUrlImage(img);

    if (link != null) {
      return link;
    } else {
      // return await firebase_storage.FirebaseStorage.instance
      //     .ref('default.jpeg')
      //     .getDownloadURL();
      return null;
    }
  }

  void addListBarangtoCart(ModelBarang modelBarang) {
    if (cart.listBarangs.isEmpty) {
      cart.listBarangs.add({
        "harga": modelBarang.harga,
        "nama": modelBarang.nama,
        "id": modelBarang.id,
        "deskripsi": modelBarang.deskripsi,
        "image": modelBarang.image,
        "imageUrl": modelBarang.imageUrl,
        "jumlah": 1,
        "total_harga": modelBarang.harga,
      });
    } else {
      var data = cart.listBarangs.firstWhere(
              (element) => element['id'] == modelBarang.id,
          orElse: () => {});

      if (data.isNotEmpty) {
        for (int i = 0; i < cart.listBarangs.length; i++) {
          print("Check Items");
          // print(cart.listBarangs[i]);
          // print(barang);
          // print(cart.listBarangs.value[i] == barang);
          // print(cart.listBarangs[i] == barang);
          // print(cart.listBarangs.value.contains(barang));
          // print(cart.listBarangs.contains(barang));
          // print(cart.listBarangs.value[i]['kode'] == barang['kode']);

          if (cart.listBarangs.value[i]['id'] == modelBarang.id) {
            print("update items");

            cart.listBarangs[i]['jumlah'] = cart.listBarangs[i]['jumlah'] + 1;
            cart.listBarangs[i]['total_harga'] =
                cart.listBarangs[i]['jumlah'] * modelBarang.harga;
          }
        }
      } else {
        cart.listBarangs.add({
          "harga": modelBarang.harga,
          "nama": modelBarang.nama,
          "id": modelBarang.id,
          "deskripsi": modelBarang.deskripsi,
          "image": modelBarang.image,
          "imageUrl": modelBarang.imageUrl,
          "jumlah": 1,
          "total_harga": modelBarang.harga,
        });
      }
    }

    print("View item list : " + cart.listBarangs.value.toString());
    cart.listBarangs.refresh();
    cart.myBasket.refresh();
    cart.totalBarangs();
    cart.totalHargas();

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar("Info", 'Successfully added to cart',
        backgroundColor: Colors.white);
  }
}
