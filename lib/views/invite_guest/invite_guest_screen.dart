import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../model/ticket_model.dart';
import '../../utils/app_color.dart';
import '../../widgets/check_box.dart';
import '../../widgets/my_widgets.dart';

class Inviteguest extends StatefulWidget {
  const Inviteguest({Key? key}) : super(key: key);

  @override
  _InviteguestState createState() => _InviteguestState();
}

class _InviteguestState extends State<Inviteguest> {
  Future<List<Map>> fetchUsers() async {
    return (await FirebaseFirestore.instance.collection('users').get())
        .docs
        .map((e) => e.data())
        .toList();
  }

  List<Storycircle> circle = [
    Storycircle(
      image: 'assets/#1.png',
    ),
    Storycircle(
      image: 'assets/#2.png',
    ),
    Storycircle(
      image: 'assets/#3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(text: 'Invite Guests'),
              Container(
                height: 45,
                width: screenwidth * 0.9,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  style: TextStyle(color: AppColors.black.withOpacity(0.6)),
                  decoration: InputDecoration(
                    errorBorder: InputBorder.none,
                    errorStyle: TextStyle(fontSize: 0, height: 0),
                    focusedErrorBorder: InputBorder.none,
                    fillColor: Colors.deepOrangeAccent[2],
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search friends to invite",
                    prefixIcon: Image.asset(
                      'assets/search.png',
                      cacheHeight: 17,
                    ),
                    hintStyle: TextStyle(color: AppColors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  itemCount: circle.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              circle[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggested',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 31,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        backgroundColor: AppColors.blue,
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 2),
                        child: Text(
                          'Invite all',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: screenheight * 0.6,
                child: FutureBuilder<List<Map>>(
                  future: fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map> users = snapshot.data ?? [];
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          Map userDoc = users[index];
                          String userName = userDoc['first'] ??
                              ""; // Replace with actual field name
                          String userImage = userDoc['image'] ??
                              ""; // Replace with actual field name
                          debugPrint("users number");
                          debugPrint(users.length.toString());
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: 57,
                            height: 57,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  height: 65,
                                  width: 57,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider(userImage),
                                  ),
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                ChecksBox(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: myText(
                    text: "Send",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
