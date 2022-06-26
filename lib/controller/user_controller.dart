import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxString email = "".obs;
  RxString name = "".obs;
  RxString role = "".obs;
  RxString address = "".obs;
  RxString image = "default.jpeg".obs;


  Future<void> asyncUser()async{
    print('cek user');
    var user = FirebaseAuth.instance.currentUser;
    if(user != null){
      print(user.email);
      var data = await FirebaseFirestore.instance.collection('users').doc(user.email).get();
      if(data.exists){
        var result = data.data();
        if(result != null){
          print(result);
          email.value = user.email!;
          name.value = result['name']??'';
          role.value = result['role']??'';
          address.value = result['address']??'';
          image.value = result['image']??'';

        }


      }
    }
  }

  Future<void> logout()async{
    email.value = '';
    name.value = '';
    role.value = '';
    address.value = '';
    await FirebaseAuth.instance.signOut();
  }
}