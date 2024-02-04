import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keypanner/controller/data_controller.dart';
import 'package:keypanner/views/notification_screen/notification_screen.dart';
import 'package:keypanner/views/profile/userfanfollwoing.dart';

import '../model/ticket_model.dart';
import '../utils/app_color.dart';
import '../views/event_page/event_page_view.dart';
import '../views/profile/add_profile.dart';

List<AustinYogaWork> austin = [
  AustinYogaWork(rangeText: '7-8', title: 'CONCERN'),
  AustinYogaWork(rangeText: '8-9', title: 'VINYASA'),
  AustinYogaWork(rangeText: '9-10', title: 'MEDITATION'),
];
List<String> imageList = [
  'assets/#1.png',
  'assets/#2.png',
  'assets/#3.png',
  'assets/#1.png',
];

Future<void> share() async {
//   await FlutterShare.share(
//       title: 'Example share',
//       text: 'Example share text',
//       linkUrl: 'https://flutter.dev/',
//       chooserTitle: 'Example Chooser Title');
}

Widget EventsFeed() {
  DataController dataController = Get.find<DataController>();

  return Obx(() => dataController.isEventsLoading.value
      ? Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return EventItem(dataController.allEvents[i]);
          },
          itemCount: dataController.allEvents.length,
        ));
}

Widget buildCard(
    {String? image,
    text,
    String? price,
    Function? func,
    DocumentSnapshot? eventData}) {
  DataController dataController = Get.find<DataController>();

  List joinedUsers = [];

  try {
    joinedUsers = eventData!.get('joined');
  } catch (e) {
    joinedUsers = [];
  }

  List dateInformation = [];
  try {
    dateInformation = eventData!.get('date').toString().split('-');
  } catch (e) {
    dateInformation = [];
  }

  List comments = [];

  List userLikes = [];
  List eventprice = [];
  try {
    userLikes = eventData!.get('likes');
  } catch (e) {
    userLikes = [];
  }
  try {
    eventprice = eventData!.get('price');
  } catch (e) {
    //  eventprice = [];
  }

  try {
    comments = eventData!.get('comments').length;
  } catch (e) {
    comments = [];
  }

  List eventSavedByUsers = [];
  try {
    eventSavedByUsers = eventData!.get('saves');
  } catch (e) {
    eventSavedByUsers = [];
  }

  return Container(
    padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: Color(393939).withOpacity(0.15),
          spreadRadius: 0.1,
          blurRadius: 2,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            func!();
          },
          child: Container(
            //  /child: Image.network(image!,fit: BoxFit.fill,),
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: NetworkImage(image!), fit: BoxFit.fill),
                // borderRadius: BorderRadius.circular(10),
                // image: DecorationImage(
                //     image: CachedNetworkImageProvider(image!),
                //     fit: BoxFit.fill,
                //     // colorFilter: ColorFilter.mode(Colors.grey, BlendMode.bl)
                //      ),
                borderRadius: BorderRadius.circular(10)),

            // width: double.infinity,
            // height: Get.width * 0.5,
            //color: Colors.red,
            child: CachedNetworkImage(
              imageUrl: image!,
              fit: BoxFit.fitWidth,
              // fadeInCurve: Curves.easeIn,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 41,
                      height: 24,
                      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Color(0xffADD8E6))),
                      child: Text(
                        '${dateInformation[0]}-${dateInformation[1]}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Flexible(
                      child: Text(
                        text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    // Text("$eventprice")
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (eventSavedByUsers
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData!.id)
                        .set({
                      'saves': FieldValue.arrayRemove(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                  } else {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData!.id)
                        .set({
                      'saves': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                  }
                },
                child: Container(
                  width: 16,
                  height: 19,
                  child: Image.asset(
                    'assets/boomMark.png',
                    fit: BoxFit.contain,
                    color: eventSavedByUsers
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              child: Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    ("Joined "),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Container(
                width: Get.width * 0.6,
                height: 50,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot user = dataController.allUsers
                        .firstWhere((e) => e.id == joinedUsers[index]);

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
                        backgroundImage: CachedNetworkImageProvider(image),
                      ),
                    );
                  },
                  itemCount: joinedUsers.length,
                  scrollDirection: Axis.horizontal,
                )),
            SizedBox(
              width: 0,
            ),
            Container(
              child: Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    ('\₹$price'),
                    //  price!,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                if (userLikes
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                } else {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffD24698).withOpacity(0.02),
                    )
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  size: 30,
                  color:
                      userLikes.contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Text(
              '${userLikes.length}',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.all(0.9),
              width: 50,
              height: 25,
              child: Image.asset(
                'assets/message.png',
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.all(0.5),
              width: 25,
              height: 20,
              child: InkWell(
                onTap: share,
                child: Image.asset(
                  'assets/send.png',
                  fit: BoxFit.contain,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

EventItem(DocumentSnapshot event) {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot user =
      dataController.allUsers.firstWhere((e) => event.get('uid') == e.id);

  String image = '';

  try {
    image = user.get('image');
  } catch (e) {
    image = '';
  }

  String eventImage = '';
  try {
    List media = event.get('media') as List;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    eventImage = mediaItem['url'];
  } catch (e) {
    eventImage = '';
  }

  return Column(
    children: [
      Container(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                        () => UserfanFollowing(user, dataController.allEvents));
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    backgroundImage: CachedNetworkImageProvider(image),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.get('first')} ${user.get('last')}',
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    Text(
                      '${user.get('username')}',
                      style: GoogleFonts.raleway(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Container(
        child: buildCard(
            image: eventImage,
            text: event.get('event_name'),
            eventData: event,
            price: event.get('price'),
            func: () {
              Get.to(() => EventPageView(event, user));
            }),
      ),
      SizedBox(
        height: 15,
      ),
    ],
  );
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
