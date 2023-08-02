import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keypanner/controller/auth_controller.dart';
import 'package:keypanner/controller/data_controller.dart';
import 'package:keypanner/utils/app_color.dart';
import 'package:keypanner/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:keypanner/views/home/home_screen.dart';
import 'package:keypanner/views/onboarding_screen.dart';
import 'package:keypanner/views/settings/aboutus.dart';
import 'package:keypanner/widgets/custom_app_bar.dart';
import 'package:keypanner/widgets/my_widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

late AuthController authController;
TextEditingController searchController = TextEditingController();
DataController dataController = Get.find<DataController>();

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: Get.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(
                func: () {
                  Get.back();
                },
                text: 'Settings',
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (String input) {
                    if (input.isEmpty) {
                      dataController.filteredEvents
                          .assignAll(dataController.allEvents);
                    } else {
                      List<DocumentSnapshot> data =
                          dataController.allEvents.value.where((element) {
                        List tags = [];

                        bool isTagContain = false;

                        try {
                          tags = element.get('tags');
                          for (int i = 0; i < tags.length; i++) {
                            tags[i] = tags[i].toString().toLowerCase();
                            if (tags[i].toString().contains(
                                searchController.text.toLowerCase())) {
                              isTagContain = true;
                            }
                          }
                        } catch (e) {
                          tags = [];
                        }
                        return (element
                                .get('location')
                                .toString()
                                .toLowerCase()
                                .contains(
                                    searchController.text.toLowerCase()) ||
                            isTagContain ||
                            element
                                .get('event_name')
                                .toString()
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()));
                      }).toList();
                      dataController.filteredEvents.assignAll(data);
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Container(
                      width: 15,
                      height: 15,
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/search.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    hintText: 'Settings',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/account.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/privacy.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Privacy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/security.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Security',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/notification.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Notification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/payment.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 20,
                        child: Image.asset(
                          'assets/order.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        child: Image.asset(
                          'assets/closeFriend.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Close Friends',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        child: Image.asset(
                          'assets/help.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBarView()),
                        );
                      },
                      child: Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10),
                // width: 57,
                // height: 57,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),

                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => BottomBarView());
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        child: Image.asset(
                          'assets/about1.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsPage()),
                        );
                      },
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                width: 13,
              ),
              Container(
                decoration: BoxDecoration(
                    // Your decoration properties
                    ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 1,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offAll(() => OnBoardingScreen());
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 21,
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Other ElevatedButton properties
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
