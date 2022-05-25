import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:gopharma/screens/home/controller/hometab_controller.dart';
import 'package:gopharma/screens/home/widgets/item_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  HomeTabController cHomeTab = Get.find<HomeTabController>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: ()async{}, child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon:
                Icon(Icons.search),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
              onChanged: (text) {
                text = text.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: cHomeTab.streamBarang(),
                builder:(BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: snapshot.data!.docs.map((DocumentSnapshot document){
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      data.addAll({
                        'id' : document.id
                      });
                      ModelBarang b = ModelBarang.fromJson(data);

                      return ItemCard(barang: b,);
                    }).toList(),
                  );
                }
            ),
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    ),);
  }
}