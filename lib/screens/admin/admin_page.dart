import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/controller/user_controller.dart';
import 'package:gopharma/model/model_barang.dart';
import 'package:gopharma/routes_name.dart';
import 'package:gopharma/screens/admin/add_barang.dart';
import 'package:gopharma/screens/admin/edit_barang.dart';
import 'package:gopharma/screens/admin/widgets/profile_card.dart';
import 'package:gopharma/utils/app_color.dart';

import 'controller/barang_controller.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  BarangController cBarang = Get.find<BarangController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Admin'),
        actions: [
          IconButton(
              onPressed: () async {
                await userController.logout();
                Navigator.pushReplacementNamed(context, routeLogin);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.pushNamed(context, addBarang);
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => ProfileCard(
                    name: userController.name.value,
                  )),
              StreamBuilder<QuerySnapshot>(
                  stream: cBarang.streamBarang,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("Kosong")));
                    }
                    if (snapshot.hasError) {
                      return const Text('Terjadi kesalahan');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("loading ...")));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("kosong")));
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.isEmpty ? 0 : 1,
                      shrinkWrap: true,
                      itemBuilder: (ctx, int) {
                        return FutureBuilder<
                                List<
                                    QueryDocumentSnapshot<
                                        Map<String, dynamic>>>>(
                            future: cBarang.getBarangs(),
                            builder: (ctx, brg) {
                              if (!brg.hasData) {
                                return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(child: Text("kosong")));
                              }
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Jumlah Barang : ${brg.data!.length}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    ...brg.data!.map((e) {
                                      Map<String, dynamic> dataBarang =
                                          e.data();
                                      dataBarang.addAll({'id': e.id});
                                      ModelBarang data =
                                          ModelBarang.fromJson(dataBarang);
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              // Navigator.pushNamed(context, editBarang);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditBarang(
                                                              modelBarang:
                                                                  data)));
                                            },
                                            // leading: FutureBuilder<String?>(
                                            //     future:
                                            //         cBarang.getImage(data.image),
                                            //     builder: (ctx, snapshot) {
                                            //       if (snapshot.connectionState ==
                                            //           ConnectionState.done) {
                                            //         if(snapshot.hasData){
                                            //           return Container(
                                            //             width: 100,
                                            //             height: 100,
                                            //             decoration: BoxDecoration(
                                            //                 border: Border.all(color: Colors.black)
                                            //             ),
                                            //             child: Image.network(
                                            //               snapshot.data
                                            //                   .toString(), fit: BoxFit.cover,),
                                            //           );
                                            //         }else{
                                            //           return Container(
                                            //             width: 100,
                                            //             height: 100,
                                            //             decoration: BoxDecoration(
                                            //                 border: Border.all(color: Colors.black)
                                            //             ),
                                            //             child: const Icon(Icons.image),
                                            //           );
                                            //         }
                                            //
                                            //       }
                                            //       return const CircularProgressIndicator();
                                            //     }),
                                            leading: data.imageUrl.isEmpty
                                                ? Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black)),
                                                    child:
                                                        const Icon(Icons.image),
                                                  )
                                                : Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black)),
                                                    child: Image.network(
                                                      data.imageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            title: Text(data.nama),
                                            subtitle: Text("Rp. ${data.harga}"),
                                            trailing: const Icon(
                                                Icons.arrow_forward_ios),
                                          ),
                                          const Divider()
                                        ],
                                      );
                                    }).toList(),
                                  ]);
                            });
                      },
                    );
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
