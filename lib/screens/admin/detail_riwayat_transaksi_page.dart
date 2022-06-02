import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/home/controller/historytab_controller.dart';
import 'package:intl/intl.dart';

import '../../utils/app_color.dart';

class DetailRiwayatTransaksiPage extends StatefulWidget {
  final Map<String, dynamic> transaksi;
  final String id;
  const DetailRiwayatTransaksiPage(
      {Key? key, required this.transaksi, required this.id})
      : super(key: key);

  @override
  _DetailRiwayatTransaksiPageState createState() => _DetailRiwayatTransaksiPageState();
}

class _DetailRiwayatTransaksiPageState extends State<DetailRiwayatTransaksiPage> {
  HistoryTabController historyC = Get.find<HistoryTabController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade400,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink.shade400,
        title: const Text(
          'Detail Transaksi',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    middleText:
                    "Apakah anda yakin menghapus riwayat transaksi ?",
                    textConfirm: "Yakin",
                    textCancel: "Tidak",
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
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Pembeli : ",
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
                const Text(
                  "Waktu : ",
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
                      ? 'Sudah dikonfirmasi'
                      : 'Belum dikonfirmasi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.transaksi['konfirmasi'] == true
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  "Total Harga : ",
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
                "Barang yang dibeli",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
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
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
