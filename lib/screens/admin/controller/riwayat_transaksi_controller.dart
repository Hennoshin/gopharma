import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RiwayatTransaksiController extends GetxController{
  final Stream<QuerySnapshot> transaksi =
  FirebaseFirestore.instance.collection('transaksi').snapshots();

  Future <List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTransaksi()async {
    var data = await FirebaseFirestore.instance.collection("transaksi").where("konfirmasi", isEqualTo: true).orderBy('waktu', descending: true).get();
    return data.docs;
  }
}