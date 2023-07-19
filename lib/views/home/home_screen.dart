import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keypanner/controller/data_controller.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/events_feed_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataController dataController = Get.find<DataController>();

  Future<void> _refreshData() async {
    // Perform the data refreshing tasks here
    // You can update the data or make API calls

    // Simulate a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));

    // Mark the refresh as completed by setting the state
    setState(() {
      EventsFeed();
      // Update the necessary data here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.03),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                Text(
                  "What's Going on Today",
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: EventsFeed(),
                ),
                Obx(() => dataController.isUsersLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : EventsIJoined()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
