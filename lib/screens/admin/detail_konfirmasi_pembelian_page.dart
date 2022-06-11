import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/admin/controller/konfirmasi_pembelian_controller.dart';
import 'package:gopharma/utils/app_color.dart';
import 'package:intl/intl.dart';

import '../../widget/loading_overlay.dart';

class DetailKonfirmasiPembelianPage extends StatefulWidget {
  final Map<String, dynamic> transaksi;
  final String id;
  const DetailKonfirmasiPembelianPage(
      {Key? key, required this.id, required this.transaksi})
      : super(key: key);

  @override
  _DetailKonfirmasiPembelianPageState createState() =>
      _DetailKonfirmasiPembelianPageState();
}

class _DetailKonfirmasiPembelianPageState
    extends State<DetailKonfirmasiPembelianPage> {
  KonfirmasiPembelianController konfirmasiController =
      Get.find<KonfirmasiPembelianController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: konfirmasiController.isLoading.value,
        child: Scaffold(
          backgroundColor: Colors.pinkAccent.shade400,
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: const Text(
              'Confirmation',
            ),
            centerTitle: true,
          ),
          body: Container(
            width: Get.width,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 22),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Name : ",
                    ),
                    Text(
                      "${widget.transaksi['pembeli']['nama'] == '' ?widget.transaksi['pembeli']['email'] :widget.transaksi['pembeli']['nama']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                      DateFormat('dd MMMM yyyy HH : mm')
                          .format(widget.transaksi['waktu'].toDate()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(),
                const Center(
                  child: Text(
                    "List of Items",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: AppColors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: ListView.separated(
                      itemCount: widget.transaksi['barangs'].length,
                      separatorBuilder: (ctx, index) =>
                          Divider(color: Colors.white),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          widget.transaksi['barangs'][index]['nama'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "RM. ${widget.transaksi['barangs'][index]['harga']}",
                        ),
                        trailing: Text(
                          "${widget.transaksi['barangs'][index]['jumlah']}x",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    print(widget.id);
                    konfirmasiController.konfirmasiBarang(widget.id);
                  },
                  child: const Text(
                    "Confirm",
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(Get.width, 50)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
