import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/admin/controller/riwayat_transaksi_controller.dart';
import 'package:gopharma/screens/admin/detail_riwayat_transaksi_page.dart';
import 'package:intl/intl.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({Key? key}) : super(key: key);

  @override
  _RiwayatTransaksiPageState createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  RiwayatTransaksiController transaksiC = Get.find<RiwayatTransaksiController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent.shade400,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title:const  Text(
            'Transaction History',
          ),
          centerTitle: true,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
              border: Border.all(color:Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: StreamBuilder<QuerySnapshot>(
            stream: transaksiC.transaksi,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return const Center(child: Text("empty"));
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              if(snapshot.data!.docs.isEmpty) return const Center(child: Text("Empty"));
              return ListView.builder(
                itemCount: snapshot.data!.docs.isEmpty ? 0 : 1,
                shrinkWrap: true,
                itemBuilder: (ctx, int) {
                  return FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                      future: transaksiC.getTransaksi(),
                      builder: (ctx, trf) {
                        if (!trf.hasData) return const Center(child: Text("Empty"));
                        return Column(
                            children: [
                              Text('Total Transaction : ${trf.data!.length}', style: TextStyle(fontWeight: FontWeight.w700),),
                              ...trf.data!.map((e) {
                                Map<String, dynamic> data = e.data();
                                var date = data['waktu'].toDate();
                                String format =
                                DateFormat('dd MMMM yyyy').format(date);

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailRiwayatTransaksiPage(
                                                      transaksi: data,
                                                      id: e.id,
                                                    )));
                                      },
                                      title: Text(
                                        format,
                                      ),
                                      subtitle: Text(
                                        data['pembeli']['nama'] == '' ? data['pembeli']['email']:data['nama']
                                      ),
                                      trailing: Text(
                                        DateFormat('H : mm').format(date),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                );
                              }).toList(),
                            ]
                        );
                      });
                },
              );
            },
          ),
        ));
  }
}
