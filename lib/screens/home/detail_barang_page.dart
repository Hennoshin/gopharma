import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../../utils/app_color.dart';

class DetailBarangPage extends StatefulWidget {
  final ModelBarang modelBarang;
  const DetailBarangPage({Key? key, required this.modelBarang})
      : super(key: key);

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  bool isLoading = false;

  _onLoading() {
    setState(() {
      isLoading = true;
    });
  }

  _offLoading() {
    setState(() {
      isLoading = false;
    });
  }

  _shareProduk() async {
    try {
      _onLoading();
      final imageUrl = widget.modelBarang.imageUrl;
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;

      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/${widget.modelBarang.image}';

      File(path).writeAsBytesSync(bytes);
      _offLoading();
      await Share.shareFiles([path],
          text:
              "${widget.modelBarang.nama} seharga RM. ${widget.modelBarang.harga} . Dapatkan sekarang juga di Go Pharma ${widget.modelBarang.imageUrl}");
    } catch (e) {
      Get.snackbar("Failed", 'There are something went wrong ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade400,
        title: Text(widget.modelBarang.nama),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: Image.network(
                widget.modelBarang.imageUrl,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.modelBarang.nama,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Rm. ${widget.modelBarang.harga}",
                    style: TextStyle(fontSize: 20, color: Colors.cyan.shade400),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Stock : ${widget.modelBarang.jumlah}",
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description :",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    widget.modelBarang.deskripsi,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
          await _shareProduk();
        },
        child: Container(
          color: Colors.cyan.shade400,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
