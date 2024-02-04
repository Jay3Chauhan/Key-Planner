import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keypanner/controller/auth_controller.dart';
import 'package:keypanner/widgets/my_widgets.dart';

import '../home/menu_screen.dart';

class FeedbackSupportScreen extends StatefulWidget {
  const FeedbackSupportScreen({super.key});

  @override
  State<FeedbackSupportScreen> createState() => _FeedbackSupportScreenState();
}

TextEditingController reporttextcontroller = TextEditingController();
TextEditingController feedbacktextcontroller = TextEditingController();
AuthController? authController;

class _FeedbackSupportScreenState extends State<FeedbackSupportScreen> {
  @override
  void initState() {
    authController = Get.put(AuthController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Text(
          'Feedback & Support',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report a problem",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: reporttextcontroller,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    hintText: "Enter your Problem here",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  autocorrect: true,
                  maxLines: 5,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: Get.height * 0.02),
                  width: Get.width,
                  child: elevatedButton(
                    text: 'Save',
                    onpress: () async {
                      authController?.isProfileInformationLoading(true);
                      print("U");
                      authController?.uploadReportData(
                        reporttextcontroller.text.trim(),
                        [
                          reporttextcontroller.text.trim(),
                        ],
                      );
                      reporttextcontroller
                          .clear(); // Clear the text in the TextField
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Feedback",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: feedbacktextcontroller,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    hintText: "Enter your Feedback here",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  autocorrect: true,
                  maxLines: 5,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: Get.height * 0.02),
                  width: Get.width,
                  child: elevatedButton(
                    text: 'Save',
                    onpress: () async {
                      authController?.isProfileInformationLoading(true);
                      print("U");
                      authController?.uploadFeedbackData(
                        feedbacktextcontroller.text.trim(),
                        [
                          feedbacktextcontroller.text.trim(),
                        ],
                      );
                      feedbacktextcontroller
                          .clear(); // Clear the text in the TextField
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
