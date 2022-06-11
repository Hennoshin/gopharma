import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../routes_name.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(22),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Text(userController.name.value.isEmpty? "name": userController.name.value),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Text(userController.email.value),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await userController.logout();
                    Navigator.pushReplacementNamed(context, routeLogin);
                  },
                  child: Text('Logout'))
            ],
          ),
        ),
      ],
    );
  }
}
