import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/admin/controller/riwayat_transaksi_controller.dart';
import 'package:gopharma/screens/admin/detail_riwayat_transaksi_page.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Border, Row;

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({Key? key}) : super(key: key);

  @override
  _RiwayatTransaksiPageState createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  RiwayatTransaksiController transaksiC =
      Get.find<RiwayatTransaksiController>();

  Future<void> _createExcel({required List data}) async {
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').setText('No');
      sheet.getRangeByName('A1').columnWidth = 4.00;
      sheet.getRangeByName('B1').setText('Time');
      sheet.getRangeByName('C1').setText('Product');
      sheet.getRangeByName('B1:C1').columnWidth = 15.00;
      sheet.getRangeByName('D1').setText('Count');
      sheet.getRangeByName('E1').setText('Price');
      sheet.getRangeByName('F1').setText('Total');
      sheet.getRangeByName('D1:F1').columnWidth = 5.00;
      sheet.getRangeByName('G1').setText('Buyer');
      sheet.getRangeByName('G1:G1').columnWidth = 20.00;
      sheet.getRangeByName('H1').setText('Buyer Address');
      sheet.getRangeByName('H1').columnWidth = 50.00;
      sheet.getRangeByName("A1:H1").cellStyle.bold = true;
      sheet.getRangeByName("A1:H1").cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByName("A1:H1").cellStyle.backColor = '#FF7396';
      int lastRow = 2;
      for (int i = 0; i < data.length; i++) {
        var date = data[i]['waktu'].toDate();
        String format = DateFormat('dd MMMM yyyy').format(date);
        List barangs = data[i]['barangs'];
        for (int j = 0; j < barangs.length; j++) {
          print("last row : "+lastRow.toString());
          print("A${i+j + 2}");
          print("${i + 1}");
          sheet.getRangeByName("A${lastRow.toString()}").setText("${lastRow - 1}");
          sheet.getRangeByName("B${lastRow.toString()}").setText(format);
          sheet.getRangeByName("C${lastRow.toString()}").setText(barangs[j]['nama']);
          sheet
              .getRangeByName("D${lastRow.toString()}")
              .setText(barangs[j]['jumlah'].toString());
          sheet
              .getRangeByName("E${lastRow.toString()}")
              .setText(barangs[j]['harga'].toString());
          sheet
              .getRangeByName("F${lastRow.toString()}")
              .setText((barangs[j]['jumlah'] * barangs[j]['harga']).toString());
          sheet.getRangeByName("G${lastRow.toString()}").setText(
              data[i]['pembeli']['nama'] == ''
                  ? data[i]['pembeli']['email']
                  : data[i]['pembeli']['nama']);
          sheet
              .getRangeByName("H${lastRow.toString()}")
              .setText(data[i]['pembeli']['address'].toString());
          lastRow++;
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/transactionList-${DateFormat('ddMMMMyyyyhhmm').format(DateTime.now())}.xlsx');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent.shade400,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text(
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
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: StreamBuilder<QuerySnapshot>(
            stream: transaksiC.transaksi,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("empty"));
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              if (snapshot.data!.docs.isEmpty)
                return const Center(child: Text("Empty"));
              return ListView.builder(
                itemCount: snapshot.data!.docs.isEmpty ? 0 : 1,
                shrinkWrap: true,
                itemBuilder: (ctx, int) {
                  return FutureBuilder<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                      future: transaksiC.getTransaksi(),
                      builder: (ctx, trf) {
                        if (!trf.hasData)
                          return const Center(child: Text("Empty"));
                        return Column(children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Total Transaction : ${trf.data!.length}',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )),
                              InkWell(
                                onTap: () {
                                  _createExcel(
                                      data: trf.data!.map((e) {
                                    Map<String, dynamic> data = e.data();

                                    return data;
                                  }).toList());
                                },
                                child: Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.table_view,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Export Excel',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          ...trf.data!.map((e) {
                            Map<String, dynamic> data = e.data();
                            var date = data['waktu'].toDate();
                            String format =
                                DateFormat('dd MMMM yyyy').format(date);

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
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
                                  subtitle: Text(data['pembeli']['nama'] == ''
                                      ? data['pembeli']['email']
                                      : data['nama']),
                                  trailing: Text(
                                    DateFormat('H : mm').format(date),
                                  ),
                                ),
                                const Divider()
                              ],
                            );
                          }).toList(),
                        ]);
                      });
                },
              );
            },
          ),
        ));
  }
}
