import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class BarangController extends GetxController {
  final Stream<QuerySnapshot> streamBarang =
      FirebaseFirestore.instance.collection('barangs').snapshots();
  CollectionReference barangs =
      FirebaseFirestore.instance.collection('barangs');
  TextEditingController cNama = TextEditingController();
  TextEditingController cHarga = TextEditingController();
  TextEditingController cJumlah = TextEditingController();
  TextEditingController cDeskripsi = TextEditingController();
  RxString urlDownload = ''.obs;

  RxBool loading = false.obs;

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

  Future<XFile?> pickImage() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    return img;
  }

  Future<void> changeAndUploadImage(String barangId) async {
    loading.value = true;
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    print("hasil image " + image.toString());

    if (image != null) {
      String fileName = basename(image.path);
      print("nama file : $fileName");

      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask task = reference.putFile(File(image.path));
      // await (await task).ref.getDownloadURL();

      await getImage(fileName).then((url) {
        if (url != null) {
          barangs.doc(barangId).set({'image': fileName, 'imageUrl': url});
        }
      });
      urlDownload.value = await (await task).ref.getDownloadURL();
    }
    loading.value = false;
  }

  Future<void> validateForm(XFile? img) async {
    Get.focusScope!.unfocus();
    if (cNama.text.isEmpty) {
      Get.snackbar("Kosong", "Nama barang harus diisi",
          backgroundColor: Colors.blue, colorText: Colors.white);
    } else if (cHarga.text.isEmpty) {
      Get.snackbar("Kosong", "harga barang harus diisi",
          backgroundColor: Colors.blue, colorText: Colors.white);
    } else if (cJumlah.text.isEmpty) {
      Get.snackbar("Kosong", "jumlah barang harus diisi",
          backgroundColor: Colors.blue, colorText: Colors.white);
    } else {
      loading.value = true;

      await Get.defaultDialog(
        title: "info",
        middleText: "Sudah yakin dengan barang anda?",
        backgroundColor: Colors.blue,
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.white,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        buttonColor: Colors.pink,
        onConfirm: () async {
          Get.back(); //close popup
          await addBarang(img);
        },
        onCancel: (){
          loading.value = false;
        },
        textConfirm: "Yakin",
        textCancel: "Batal",
      );
    }
  }

  Future<void> addBarang(XFile? image) async {
    loading.value = true;

    Map<String, dynamic> barang = {
      "nama": cNama.text,
      "harga": int.parse(cHarga.text),
      "deskripsi": cDeskripsi.text,
      "jumlah": int.parse(cJumlah.text),
      "image": "default.jpg",
      "imageUrl": "https://firebasestorage.googleapis.com/v0/b/gopharma-347807.appspot.com/o/default.jpg?alt=media&token=8b0c3a8e-ac29-4bb7-9b6a-f491f57f6a0f",
      "create_at": DateTime.now(),
      "update_at": DateTime.now(),
    };
    await barangs.add(barang).then((value) async {
      if (image != null) {
        String fileName = basename(image.path);
        print("nama file : $fileName");

        Reference reference = FirebaseStorage.instance.ref().child(fileName);
        await reference.putFile(File(image.path));

        await getImage(fileName).then((url) {
          if (url != null) {
            barangs.doc(value.id).update({'imageUrl': url,'image': fileName});
          }
          Get.snackbar("Berhasil", 'Berhasil Menambah Barang',
              backgroundColor: Colors.blue);
        });

        loading.value = false;
      } else {
        loading.value = false;
        Get.snackbar("Berhasil", 'Berhasil Menambah Barang',
            backgroundColor: Colors.blue);
      }
    }).catchError((error) {
      loading.value = false;
      Get.snackbar("Gagal", 'Barang Gagal diubah', backgroundColor: Colors.red);
    });

    cNama.clear();
    cHarga.clear();
    cJumlah.clear();
    cDeskripsi.clear();
  }

  Future<void> simpanEditBarang(
      {required ModelBarang modelBarang, XFile? imageFile}) async {
    Get.focusScope!.unfocus();
    loading.value = true;


    await Get.defaultDialog(
      title: "info",
      middleText: "Sudah yakin dengan barang anda?",
      backgroundColor: Colors.blue,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      buttonColor: Colors.pink,
      onConfirm: () async {
        Get.back(); //close popup
        Map<String, dynamic> barang = {
          "nama": modelBarang.nama,
          "harga": modelBarang.harga,
          "deskripsi": modelBarang.deskripsi,
          "jumlah": modelBarang.jumlah,
          "image": modelBarang.image,
          "imageUrl": modelBarang.imageUrl,
          "update_at": DateTime.now(),
        };
        await barangs.doc(modelBarang.id).update(barang).then((value) async {
          if (imageFile != null) {
            String fileName = basename(imageFile.path);
            print("nama file : $fileName");

            Reference reference =
                FirebaseStorage.instance.ref().child(fileName);
            await reference.putFile(File(imageFile.path));
            // await (await task).ref.getDownloadURL();
            await getImage(fileName).then((url) {
              if (url != null) {
                 barangs.doc(modelBarang.id).update({'image': fileName,'imageUrl': url});
                 final storage = FirebaseStorage.instance.ref();
                 storage.child(modelBarang.image).delete();
              }
              Get.snackbar("Berhasil", 'Barang berhasil diubah',
                  backgroundColor: Colors.blue);
            });
            loading.value = false;
          }else{
            loading.value = false;
            Get.snackbar("Berhasil", 'Barang berhasil diubah',
                backgroundColor: Colors.blue, colorText: Colors.white);
          }

        }).catchError((error) {
          loading.value = false;
          Get.back(); //close popup
          Get.snackbar("Gagal", 'Barang Gagal diubah',
              backgroundColor: Colors.red);
        });
      },
      onCancel: (){
        loading.value = false;
      },
      textConfirm: "Yakin",
      textCancel: "Batal",
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBarangs() async {
    var data = await FirebaseFirestore.instance
        .collection("barangs")
        .orderBy('update_at', descending: true)
        .get();
    return data.docs;
  }

  Future<void> deleteBarang(ModelBarang modelBarang) async {
    Get.defaultDialog(
      title: "info",
      middleText: "Sudah yakin dengan barang anda?",
      backgroundColor: Colors.blue,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      buttonColor: Colors.pink,
      onConfirm: () async {
        barangs.doc(modelBarang.id).delete().then((value) {
          Get.snackbar("Success", "Berhasil hapus barang",
              backgroundColor: Colors.blue, colorText: Colors.white);
          final storage = FirebaseStorage.instance.ref();
          storage.child(modelBarang.image).delete();
        }).catchError((error) {
          Get.snackbar("Gagal", "Gagal hapus barang",
              backgroundColor: Colors.blue, colorText: Colors.white);
        });
        Get.back(); //close popup
        Get.back(); //close page
      },
      textConfirm: "Yakin",
      textCancel: "Batal",
    );
  }
}
