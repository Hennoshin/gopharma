import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:gopharma/screens/home/controller/hometab_controller.dart';

class ItemCard extends StatefulWidget {
  final ModelBarang barang;
  const ItemCard({Key? key, required this.barang}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  HomeTabController cHome = Get.find<HomeTabController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 2 - 40,
      child: Column(
        children: [
          FutureBuilder<String?>(
              future: cHome.getImage(widget.barang.image),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Image.network(
                        snapshot.data.toString(),
                        fit: BoxFit.fill,
                      ),
                    );
                  } else {
                    return Container(
                      width: Get.width / 2 - 40,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: const Icon(Icons.image),
                    );
                  }
                }
                return const CircularProgressIndicator();
              }),
          const SizedBox(
            height: 4,
          ),
          Text(
            widget.barang.nama,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'RM ${widget.barang.harga}',
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            width: (Get.width / 2 - 40) / 1.5,
            margin: const EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.pink, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
