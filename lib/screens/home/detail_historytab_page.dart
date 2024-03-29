import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/home/controller/historytab_controller.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../utils/app_color.dart';

class DetailHistoryTabPage extends StatefulWidget {
  final Map<String, dynamic> transaksi;
  final String id;
  const DetailHistoryTabPage(
      {Key? key, required this.transaksi, required this.id})
      : super(key: key);

  @override
  _DetailHistoryTabPageState createState() => _DetailHistoryTabPageState();
}

class _DetailHistoryTabPageState extends State<DetailHistoryTabPage> {
  HistoryTabController historyC = Get.find<HistoryTabController>();

  void generatePDF(
      {required String pembeli,
        required String waktu,
        required String total,
        required List barangs}) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text("Buyer : $pembeli"),
            pw.Text("Time : $waktu"),
            pw.Text("Total Price : RM. $total"),
            pw.SizedBox(height: 50),
            pw.Center(child: pw.Text("Purchased Item")),
            pw.Divider(),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: barangs
                    .map((e) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(e['nama']),
                      pw.Text("RM. ${e['harga']}"),
                      pw.Text("Jumlah ${e['jumlah']} X"),
                      pw.Divider(),
                    ]))
                    .toList())
          ];
        }));

    Uint8List bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transaction-$waktu-${DateFormat('hhmm').format(DateTime.now())}.pdf');

    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade400,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan.shade400,
        title: const Text(
          'Detail Transaction',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    middleText:
                    "Are you sure want to delete your shopping history ?",
                    textConfirm: "Sure",
                    textCancel: "No",
                    title: 'Konfirmasi',
                    buttonColor: Colors.pinkAccent,
                    confirmTextColor: Colors.white,
                    cancelTextColor: Colors.black,
                    onConfirm: () {
                      Get.back();
                      historyC.deleteHistoryOrder(widget.id);
                      Get.back();
                    });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Container(
        width: Get.width,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 22),
        decoration: BoxDecoration(
            color: Colors.cyan.shade400,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Buyer : ",
                ),
                Text(
                  "${widget.transaksi['pembeli']['nama'] == '' ? widget.transaksi['pembeli']['email'] : widget.transaksi['pembeli']['nama']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text("Address : "),
                Text(
                  widget.transaksi["pembeli"]["address"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ]
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  "Time : ",
                ),
                Text(
                  DateFormat('dd MMMM yyyy')
                      .format(widget.transaksi['waktu'].toDate()),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  "Status : ",
                ),
                Text(
                  widget.transaksi['konfirmasi'] == true
                      ? 'Confirmed'
                      : 'Not Confirmed',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.transaksi['konfirmasi'] == true
                          ? Colors.white
                          : Colors.red),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  "Total Price : ",
                ),
                Text(
                  'RM. ' + widget.transaksi['total_harga'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Center(
              child: Text(
                "Purchased Items",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white),
                    color: AppColors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.separated(
                  itemCount: widget.transaksi['barangs'].length,
                  separatorBuilder: (ctx, index) =>
                  const Divider(color: Colors.white),
                  itemBuilder: (ctx, index) => ListTile(
                    title: Text(
                      widget.transaksi['barangs'][index]['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "RM ${widget.transaksi['barangs'][index]['harga']}",
                    ),
                    trailing: Text(
                      "${widget.transaksi['barangs'][index]['jumlah']}x",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: (){
                generatePDF(
                    pembeli: widget.transaksi['pembeli']['nama'] == '' ? widget.transaksi['pembeli']['email'] : widget.transaksi['pembeli']['nama'],
                    waktu: DateFormat('dd MMMM yyyy')
                        .format(widget.transaksi['waktu'].toDate()),
                    total: widget.transaksi['total_harga'].toString(),
                    barangs: widget.transaksi['barangs']);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)
                ),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Generate PDF",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}