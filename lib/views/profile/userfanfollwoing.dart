import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:keypanner/controller/data_controller.dart';
import 'package:keypanner/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:keypanner/views/home/home_screen.dart';
import 'package:keypanner/views/home/menu_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:keypanner/views/onboarding_screen.dart';
import 'package:keypanner/widgets/events_feed_widget.dart';

import '../../model/ticket_model.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class UserfanFollowing extends StatefulWidget {
  DocumentSnapshot? myDocument;
  DocumentSnapshot<Object?> user;
  UserfanFollowing(this.user, this.allEvents);

  var allUsers = <DocumentSnapshot>[].obs;
  var filteredUsers = <DocumentSnapshot>[].obs;
  var allEvents = <DocumentSnapshot>[].obs;
  var filteredEvents = <DocumentSnapshot>[].obs;
  var joinedEvents = <DocumentSnapshot>[].obs;
  DataController dataController = Get.find<DataController>();

  @override
  _UserfanFollowingState createState() => _UserfanFollowingState();
}

class FirebaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot<Object?>> getUserData(String userId) async {
    return await _usersCollection.doc(userId).get();
  }
}

class _UserfanFollowingState extends State<UserfanFollowing> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  List<Ticketdetail> ticket = [
    Ticketdetail(
        color: Color(0xffADD8E6),
        date: 'Feb 28',
        range: '10-11',
        name: 'BRUNCH',
        img1: 'assets/#1.png',
        img2: 'assets/#2.png',
        img3: 'assets/#3.png',
        img4: 'assets/#1.png',
        img5: 'assets/#3.png',
        img6: 'assets/#3.png',
        heart: 'assets/heart.png',
        count: '5.2k',
        message: 'assets/message.png',
        rate: '140',
        share: 'assets/send.png'),
    Ticketdetail(
        color: Color(0xff0000FF),
        date: 'may 14',
        range: '6-7:30',
        name: 'BRUNCH',
        img1: 'assets/#1.png',
        img2: 'assets/#2.png',
        img3: 'assets/#3.png',
        img4: 'assets/#1.png',
        img5: 'assets/#3.png',
        img6: 'assets/#3.png',
        heart: 'assets/heart2.png',
        count: '5.2k',
        message: 'assets/message.png',
        rate: '150',
        share: 'assets/send.png'),
  ];

  bool isNotEditable = true;

  DataController? dataController;

  int? followers = 0, following = 0;
  String image = '';

  // @override
  // initState() {
  //   super.initState();
  //   dataController = Get.find<DataController>();

  //   firstNameController.text = dataController!.myDocument!.get('first');
  //   lastNameController.text = dataController!.myDocument!.get('last');

  //   try {
  //     descriptionController.text = dataController!.myDocument!.get('desc');
  //   } catch (e) {
  //     descriptionController.text = '';
  //   }

  //   try {
  //     image = dataController!.myDocument!.get('image');
  //   } catch (e) {
  //     image = '';
  //   }

  //   try {
  //     locationController.text = dataController!.myDocument!.get('location');
  //   } catch (e) {
  //     locationController.text = '';
  //   }

  //   try {
  //     followers = dataController!.myDocument!.get('followers').length;
  //   } catch (e) {
  //     followers = 0;
  //   }

  //   try {
  //     following = dataController!.myDocument!.get('following').length;
  //   } catch (e) {
  //     following = 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          widget.user.get('username'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () {},
            child: Image(
              image: AssetImage('assets/sms.png'),
              width: 28,
              height: 25,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          InkWell(
            onTap: () {
              Get.to(() => MenuScreen());
            },
            child: Image(
              image: AssetImage('assets/menu.png'),
              width: 23.33,
              height: 19,
            ),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(
                                left: Get.width * 0.75, top: 20, right: 20),
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ),
                        ),
                        Align(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 90, horizontal: 20),
                            width: Get.width,
                            height: isNotEditable ? 240 : 310,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  margin: EdgeInsets.only(top: 35),
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.circular(70),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff7DDCFB),
                                        Color(0xffBC67F2),
                                        Color(0xffACF6AF),
                                        Color(0xffF95549),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                        ),
                                        child: snapshot.data != null
                                            ? CircleAvatar(
                                                radius: 56,
                                                backgroundColor: Colors.white,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  snapshot.data!['image'],
                                                ))
                                            : CircleAvatar(
                                                radius: 56,
                                                backgroundColor: Colors.white,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  image,
                                                )),
                                        // child: Image.asset(
                                        //   'assets/profilepic.png',
                                        //   fit: BoxFit.contain,
                                        // ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              Container(
                                height: 25,
                                child: Text(
                                  snapshot.data!['first'] +
                                      " " +
                                      snapshot.data!['last'],
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                // width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(horizontal: 14),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(snapshot.data!['desc']),
                              Text(snapshot.data!['location']),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${followers}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: -0.3,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 35,
                                      color: Color(0xff918F8F).withOpacity(0.5),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${following}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -0.3),
                                        ),
                                        Text(
                                          "Following",
                                          style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: -0.3,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      width: screenwidth * 0.25,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            backgroundColor: AppColors.blue),
                                        onPressed: () {},
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(top: 10),
                              //   width: Get.width * 0.6,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: Color(0xffE2E2E2),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(5),
                              //           child: Icon(
                              //             Icons.add,
                              //           ),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: AppColors.blue,
                              //         ),
                              //         child: Image(
                              //           image: AssetImage('assets/#1.png'),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: AppColors.blue,
                              //         ),
                              //         child: Image(
                              //           image: AssetImage('assets/#3.png'),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: AppColors.blue,
                              //         ),
                              //         child: Image(
                              //           image: AssetImage('assets/#2.png'),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: AppColors.blue,
                              //         ),
                              //         child: Image(
                              //           image: AssetImage('assets/#3.png'),
                              //         ),
                              //       ),
                              //       Container(
                              //         width: 34,
                              //         height: 34,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(36),
                              //           color: AppColors.blue,
                              //         ),
                              //         child: Image(
                              //           image: AssetImage('assets/#1.png'),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 40,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        width: 53,
                                        height: 53,
                                        child: Image.asset(
                                          'assets/Group 26.png',
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        width: 53,
                                        height: 53,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(36),
                                          color: Colors.white,
                                        ),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/Ellipse 984.png')),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        width: 53,
                                        height: 53,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(36),
                                          color: Colors.white,
                                        ),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/Ellipse 985.png')),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        width: 53,
                                        height: 53,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(36),
                                          color: Colors.white,
                                        ),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/Ellipse 986.png')),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 30, top: 10),
                                    child: Text(
                                      'NEW',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: DefaultTabController(
                                  length: 2,
                                  initialIndex: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black,
                                              width: 0.01,
                                            ),
                                          ),
                                        ),
                                        child: TabBar(
                                          indicatorColor: Colors.black,
                                          labelPadding: EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                            vertical: 10,
                                          ),
                                          unselectedLabelColor: Colors.black,
                                          tabs: [
                                            Tab(
                                              icon: Image.asset(
                                                  "assets/ticket.png"),
                                              height: 20,
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                  "assets/Group 18600.png"),
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: screenheight * 0.46,
                                        //height of TabBarView
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: TabBarView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemCount: ticket.length,
                                                itemBuilder: (context, index) {
                                                  return
                                                      // InkWell(onTap: (){
                                                      // Get.to(()=>Detailproduct(record: popular[index],));
                                                      // },
                                                      Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    width: 388,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.15),
                                                          spreadRadius: 2,
                                                          blurRadius: 3,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, left: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            height: 41,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                6,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: ticket[
                                                                        index]
                                                                    .color!,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                myText(
                                                                  text: ticket[
                                                                          index]
                                                                      .range,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                myText(
                                                                  text: ticket[
                                                                          index]
                                                                      .date,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                snapshot.data![
                                                                        'first'] +
                                                                    " " +
                                                                    snapshot.data![
                                                                        'last']
                                                                // '${ticket[index].name}',
                                                                ,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img1}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img2}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img3}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img4}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img5}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].img6}'),
                                                                    width: 27,
                                                                    height: 27,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 30,
                                                                    child: Image
                                                                        .asset(
                                                                      ticket[index]
                                                                          .heart,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 1,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      '${ticket[index].count}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 23,
                                                                  ),
                                                                  Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].message}'),
                                                                    width: 16,
                                                                    height: 16,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      '${ticket[index].rate}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 27,
                                                                  ),
                                                                  Container(
                                                                      child:
                                                                          Image(
                                                                    image: AssetImage(
                                                                        '${ticket[index].share}'),
                                                                    width: 15,
                                                                    height: 15,
                                                                  )),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            Container(
                                              child: Center(
                                                child: Text('Tab 2',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

EventsIJoined() {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot myUser = dataController.allUsers
      .firstWhere((e) => e.id == FirebaseAuth.instance.currentUser!.uid);

  String userImage = '';
  String userName = '';

  try {
    userImage = myUser.get('image');
  } catch (e) {
    userImage = '';
  }

  try {
    userName = '${myUser.get('first')} ${myUser.get('last')}';
  } catch (e) {
    userName = '';
  }

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/doneCircle.png',
              fit: BoxFit.cover,
              color: AppColors.blue,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      SizedBox(
        height: Get.height * 0.015,
      ),
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                // CircleAvatar(
                //   backgroundImage: NetworkImage(userImage),
                //   radius: 20,
                // ),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    userImage,
                  ),
                  // child: Icon(Icons.error),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Divider(
              color: Color(0xff918F8F).withOpacity(0.2),
            ),
            Obx(
              () => dataController.isEventsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.joinedEvents.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.joinedEvents[i].get('event_name');

                        String date =
                            dataController.joinedEvents[i].get('date');

                        date = date.split('-')[0] + '-' + date.split('-')[1];

                        List joinedUsers = [];

                        try {
                          joinedUsers =
                              dataController.joinedEvents[i].get('joined');
                        } catch (e) {
                          joinedUsers = [];
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 41, height: 24,
                                    alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Color(0xffADD8E6),
                                      ),
                                    ),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.06,
                                  ),
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: Get.width * 0.6,
                                height: 50,
                                child: ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    DocumentSnapshot user =
                                        dataController.allUsers.firstWhere(
                                            (e) => e.id == joinedUsers[index]);

                                    String image = '';

                                    try {
                                      image = user.get('image');
                                    } catch (e) {
                                      image = '';
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        minRadius: 13,
                                        backgroundImage:
                                            CachedNetworkImageProvider(image),
                                      ),
                                    );
                                  },
                                  itemCount: joinedUsers.length,
                                  scrollDirection: Axis.horizontal,
                                )),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
