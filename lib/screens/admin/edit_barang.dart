import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:gopharma/screens/admin/controller/barang_controller.dart';
import 'package:gopharma/widget/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';

class EditBarang extends StatefulWidget {
  final ModelBarang modelBarang;
  const EditBarang({Key? key, required this.modelBarang}) : super(key: key);

  @override
  _EditBarangState createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  BarangController cBarang = Get.find<BarangController>();
  XFile? _imageUpload;
  bool loadingImg = false;

  TextEditingController cNama = TextEditingController();
  TextEditingController cHarga = TextEditingController();
  TextEditingController cJumlah = TextEditingController();
  TextEditingController cDeskripsi = TextEditingController();

  _onLoadingImg() {
    setState(() {
      loadingImg = true;
    });
  }

  _offLoadingImg() {
    setState(() {
      loadingImg = false;
    });
  }

  @override
  void initState() {
    cNama = TextEditingController(text: widget.modelBarang.nama.toString());
    cHarga = TextEditingController(text: widget.modelBarang.harga.toString());
    cJumlah = TextEditingController(text: widget.modelBarang.jumlah.toString());
    cDeskripsi =
        TextEditingController(text: widget.modelBarang.deskripsi.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(()=>LoadingOverlay(
          isLoading: cBarang.loading.value,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pink,
                title: Text('Edit Barang'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          _imageUpload = await cBarang.pickImage();
                          setState(() {
                           });
                        },
                        child: Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 2, color: Colors.black)),
                            child: _imageUpload == null
                                ? Image.network(
                                        widget.modelBarang.imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                : Image.file(
                                    File(_imageUpload!.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: cNama,
                        decoration: InputDecoration(
                          hintText: 'Nama Barang',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: cHarga,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9)
                        ],
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Text("Rp. "),
                          ),
                          hintText: 'Masukan Harga Barang',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: cJumlah,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3)
                        ],
                        decoration: InputDecoration(
                          hintText: 'Jumlah Barang',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: cDeskripsi,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Deskripsi Barang',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  cBarang.deleteBarang(widget.modelBarang);
                                },
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  cBarang.simpanEditBarang(
                                      modelBarang: ModelBarang(
                                        id: widget.modelBarang.id,
                                        nama: cNama.text,
                                        harga: int.parse(cHarga.text),
                                        jumlah: int.parse(cJumlah.text),
                                        deskripsi: cDeskripsi.text,
                                        image: widget.modelBarang.image,
                                        imageUrl: widget.modelBarang.imageUrl,
                                      ),
                                      imageFile: _imageUpload);
                                },
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
