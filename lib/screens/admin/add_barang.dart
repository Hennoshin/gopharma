import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/admin/controller/barang_controller.dart';
import 'package:gopharma/utils/app_color.dart';
import 'package:gopharma/widget/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';

class AddBarang extends StatefulWidget {
  const AddBarang({Key? key}) : super(key: key);

  @override
  State<AddBarang> createState() => _AddBarangState();
}

class _AddBarangState extends State<AddBarang> {
  BarangController cBarang = Get.find<BarangController>();
  XFile? _imageUpload;

  bool loading = false;

  _onLoading() => setState(() => loading = true);
  _offLoading() => setState(() => loading = false);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
            () => LoadingOverlay(
          isLoading: cBarang.loading.value,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink,
              title: Text('Add Items'),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        _imageUpload = await cBarang.pickImage();
                        setState(() {});
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2, color: Colors.black)),
                        child: _imageUpload == null
                            ? const Icon(Icons.add_a_photo)
                            : Image.file(
                          File(_imageUpload!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: cBarang.cNama,
                      decoration: InputDecoration(
                        hintText: 'Name',
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
                      controller: cBarang.cHarga,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9)
                      ],
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: null,
                          icon: Text("RM. "),
                        ),
                        hintText: 'Price',
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
                      controller: cBarang.cJumlah,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      decoration: InputDecoration(
                        hintText: 'Amount of Items',
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
                      controller: cBarang.cDeskripsi,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () async {
                          await cBarang.validateForm(_imageUpload);
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}