import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/admin/controller/konfirmasi_pembelian_controller.dart';
import 'package:gopharma/screens/admin/detail_konfirmasi_pembelian_page.dart';
import 'package:intl/intl.dart';

class KonfirmasiPembayaranPage extends StatefulWidget {
  const KonfirmasiPembayaranPage({Key? key}) : super(key: key);

  @override
  _KonfirmasiPembayaranPageState createState() => _KonfirmasiPembayaranPageState();
}

class _KonfirmasiPembayaranPageState extends State<KonfirmasiPembayaranPage> {
  KonfirmasiPembelianController konfirmasiPembayaran = Get.find<KonfirmasiPembelianController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent.shade400,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: const Text(
            'Konfirmasi Pembelian',
          ),
          centerTitle: true,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: StreamBuilder<QuerySnapshot>(
            stream: konfirmasiPembayaran.transaksi,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return Center(child: Text("kosong"));
              }
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.data!.docs.isEmpty) return Center(child: Text("kosong"));
              return ListView.builder(
                itemCount: snapshot.data!.docs.isEmpty ? 0 : 1,
                shrinkWrap: true,
                itemBuilder: (ctx, int) {
                  return FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                      future: konfirmasiPembayaran.getTransaksi(),
                      builder: (ctx, trf) {
                        if (!trf.hasData) return Center(child: Text("kosong"));
                        if (trf.data!.isEmpty) return Center(child: Text("kosong"));
                        return Column(
                          children: trf.data!.map((e) {
                            Map<String, dynamic> data = e.data();
                            var date = data['waktu'].toDate();
                            String format =
                            DateFormat('dd MMMM yyyy HH:mm').format(date);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailKonfirmasiPembelianPage(id: e.id, transaksi: data)));
                                  },
                                  title: Text(
                                    data['pembeli']['nama'] == '' ?data['pembeli']['email'] :data['pembeli']['nama'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    format,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Container(
                                    color: Colors.pinkAccent.shade400,
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Cek',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }).toList(),
                        );
                      });
                },
              );
            },
          ),
        ));

  }
}
