import 'package:get/get.dart';

class CartController extends GetxController {
  RxList myBasket = [].obs;
  RxList<Map<String, dynamic>> listBarangs = <Map<String, dynamic>>[].obs;
  RxInt totalBarang = 0.obs;
  RxInt totalHarga = 0.obs;


  void totalBarangs(){
    totalBarang.value=0;
    for (var element in listBarangs) {
      totalBarang += element['jumlah'];
    }
  }

  void totalHargas(){
    print('hitung harga');
    totalHarga.value=0;
    for (var element in listBarangs) {
      totalHarga += element['total_harga'];
    }

    totalHarga.refresh();
    listBarangs.refresh();
  }


}