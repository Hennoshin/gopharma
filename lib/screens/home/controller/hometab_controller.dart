import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeTabController extends GetxController{

  Stream<QuerySnapshot<Map<String, dynamic>>> streamBarang(){
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
}