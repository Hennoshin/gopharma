import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/screens/home/controller/historytab_controller.dart';
import 'package:gopharma/screens/home/detail_historytab_page.dart';
import 'package:intl/intl.dart';

import '../../utils/app_color.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  HistoryTabController historyC = Get.find<HistoryTabController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 22),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: AppColors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(22)),
        child: StreamBuilder<QuerySnapshot>(
          stream: historyC.transaksi,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text("empty"));
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("empty"));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Shopping List",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  ListView.builder(
                    itemCount: snapshot.data!.docs.isEmpty ? 0 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, int) {
                      return FutureBuilder<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                          future: historyC.getTransaksi(),
                          builder: (ctx, trf) {
                            if (!trf.hasData)
                              return Center(child: Text("empty"));
                            return Column(
                              children: trf.data!.map((e) {
                                Map<String, dynamic> data = e.data();
                                var date = data['waktu'].toDate();
                                String format =
                                DateFormat('dd MMMM yyyy').format(date);

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailHistoryTabPage(
                                                      transaksi: data,
                                                      id: e.id,
                                                    )));
                                      },
                                      title: Text(
                                        format,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        data['konfirmasi'] == true
                                            ? 'Confirmed'
                                            : 'Not Confirmed',
                                        style: TextStyle(
                                            color: data['konfirmasi'] == true
                                                ? Colors.white
                                                : Colors.red),
                                      ),
                                      trailing: Text(
                                        DateFormat('H : mm').format(date),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              }).toList(),
                            );
                          });
                    },
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            );
          },
        ));
  }
}