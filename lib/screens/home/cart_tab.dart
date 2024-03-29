import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/utils/app_color.dart';

import '../../controller/user_controller.dart';
import 'controller/carttab_controller.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  CartController cart = Get.find<CartController>();
  UserController userController = Get.find<UserController>();

  final TextEditingController _textController = TextEditingController();

  void _confirm(BuildContext context) async {
    await userController.asyncUser();
    _textController.text = userController.address.value;

    String confirmation = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Confirm Order"),
          content: TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: "Address"
            ),
          ),
          actions: [
            OutlinedButton(
                onPressed: () => Navigator.pop(context, ""),
                child: const Text("Cancel")
            ),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, _textController.value.text),
                child: const Text("Confirm")
            )
          ],
        )
    ) ?? "";

    if (confirmation == "") {
      return;
    }

    Map<String, dynamic> transaksi = {
      "barangs": cart.listBarangs.value,
      "konfirmasi": false,
      "pembeli": {
        "email": userController.email.value,
        "nama": userController.name.value,
        "image": userController.image.value,
        "address": confirmation
      },
      "total_harga": cart.totalHarga.value,
      "total_barang": cart.totalBarang.value,
      "waktu": DateTime.now()
    };
    print(transaksi);
    Get.back();
    cart.addTransaction(transaksi);

    cart.sendNotification(userController.email.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => cart.listBarangs.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(
                  "Total Price : ",
                ),
                Expanded(
                  child: Obx(
                        () => Text(
                      "RM. ${cart.totalHarga}",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _confirm(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          )
              : SizedBox()),
          Obx(
                () => cart.listBarangs.isEmpty
                ? SizedBox()
                : Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  cart.listBarangs.clear();
                  cart.totalBarang.value = 0;
                  cart.totalHarga.value = 0;
                  cart.listBarangs.refresh();
                },
                label: Icon(Icons.delete_forever),
                icon: Text("Delete All"),
              ),
            ),
          ),
          Obx(
                () => cart.listBarangs.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "Shopping Cart is Empty",
                ),
              ),
            )
                : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cart.listBarangs.length,
                separatorBuilder: (ctx, index) => Divider(),
                itemBuilder: (ctx, index) => ListTile(
                    isThreeLine: true,
                    leading: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(cart
                                  .listBarangs.value[index]['imageUrl']))),
                    ),
                    title: Text(
                      cart.listBarangs.value[index]['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "RM. ${cart.listBarangs[index]['harga'].toString()}"),
                        InkWell(
                          onTap: () {
                            int ubah = cart.listBarangs[index]['jumlah'];
                            Get.defaultDialog(
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.pink,
                                textConfirm: "Save",
                                textCancel: "Cancel",
                                cancelTextColor: Colors.pink,
                                onConfirm: () {
                                  print("oke");
                                  cart.listBarangs[index]['jumlah'] = ubah;
                                  cart.listBarangs[index]['total_harga'] =
                                      ubah *
                                          cart.listBarangs[index]['harga'];
                                  cart.totalBarangs();
                                  cart.totalHargas();
                                  Get.back();
                                  cart.listBarangs.refresh();
                                },
                                content: Column(
                                  children: [
                                    TextField(
                                      onChanged: (v) {
                                        print(v);
                                        ubah = int.parse(v);
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText:
                                        "${cart.listBarangs[index]['jumlah']}",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.remove),
                              SizedBox(
                                width: 2,
                              ),
                              Text(cart.listBarangs[index]['jumlah']
                                  .toString()),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          cart.listBarangs.removeAt(index);
                          cart.totalBarangs();
                          cart.totalHargas();
                          cart.listBarangs.refresh();
                        },
                        icon: Icon(Icons.delete)))),
          ),
        ],
      ),
    );
  }
}