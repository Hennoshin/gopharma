import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/utils/app_color.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  const ProfileCard({Key? key, this.name = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: Get.height * 0.2,
      width: Get.width,
      decoration: const BoxDecoration(
          color: Colors.pink,),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.4),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: -20,
            left: -50,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.4),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.4),
                  shape: BoxShape.circle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      ' $name',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
