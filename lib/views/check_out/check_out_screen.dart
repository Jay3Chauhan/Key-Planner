import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keypanner/services/payment_service/makepaymentwithrazorpay.dart';
import 'package:keypanner/services/payment_service/payment_service.dart';
import 'package:keypanner/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:keypanner/views/home/home_screen.dart';
import 'package:keypanner/views/home/menu_screen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CheckOutView extends StatefulWidget {
  DocumentSnapshot? eventDoc;

  CheckOutView(this.eventDoc);

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  int selectedRadio = 0;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
  }

  String eventImage = '';

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();

    try {
      List media = widget.eventDoc!.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment is successful. Please close.'),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                sendConfirmationEmaild();
                joinEvent(widget.eventDoc!.id);
                Navigator.of(context).pop();
                Get.offAll(() => BottomBarView());
              },
            ),
          ],
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
  var _razorpay = Razorpay();
  String? _paymentId;
  String calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  String useremaild = FirebaseAuth.instance.currentUser!.email ?? "";
  String userfullname = dataController.myDocument!.get('first') ?? "";
  //String userfullname = FirebaseAuth.instance.currentUser!.email ?? "";
  //String usermobilenumber =
  // FirebaseAuth.instance.currentUser!.phoneNumber ?? "";
  void makepaymentWithRazorpay(
      {required String amount, required String eventId}) {
    final options = {
      'key': 'rzp_test_rosARnIA70Su82',
      'amount': int.parse(widget.eventDoc!.get('price')) *
          100, //in the smallest currency sub-unit.
      'name': 'Key Planner',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': (widget.eventDoc!.get('event_name')),
      'timeout': 300, // in seconds
      'prefill': {
        'contact': "usermobilenumber",
        'email': useremaild,
        'name': userfullname,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      },
    };
    options;
    _razorpay.open(options);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> sendConfirmationEmaild() async {
    // final smtpServer = gmail('jay.cse@snpitrc.ac.in', 'dqkepdmwwggcuakh');
    final smtpServer = gmail('ceremomanagement@gmail.com', 'mxlvgpzyfiijfvza');

    final message = Message()
      ..from = Address('csejaychauhan@gmail.com', 'Jay Chauhan')
      ..recipients.add(useremaild) // User's email
      ..subject = 'Payment Confirmation and Booking Details'
      ..text = 'Thank you for your payment!\n\n'
          'Your payment ID: \n\n'
          'Booking details: ${widget.eventDoc!['event_name']} on ${widget.eventDoc!['date']}'
      ..html = """
<!DOCTYPE html>
<html>0
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Event Booking Confirmation</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .header {
      text-align: center;
      padding: 20px 0;
    }

    .logo {
      display: block;
      margin: 0 auto;
      max-width: 150px;
      height: auto;
    }

    .content {
      padding: 20px;
      color: #333333;
    }

    .event-details {
      border: 1px solid #dddddd;
      background-color: #f9f9f9;
      padding: 15px;
      margin-top: 20px;
      border-radius: 8px;
      overflow: hidden; /* Clear floats */
    }

    .eventphoto {
      float: left;
      width: 150px;
      height: auto;
    }

    .event-details-content {
      float: left;
      width: 90%;
      padding-left: 20px;
    }

    .footer {
      text-align: center;
      padding: 20px;
      background-color: #f9f9f9;
      border-bottom-left-radius: 8px;
      border-bottom-right-radius: 8px;
    }

    .footer-text {
      color: #999999;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <img class="logo" src="https://www.linkpicture.com/q/Ceremo-Logo-1.png" alt="Event Logo">
    </div>
    <div class="content">
      <h2>Thank You for Booking an Event!</h2>
      <p>Dear $userfullname,</p>
      <p>We are delighted to confirm your booking for the following event:</p>
      
      <div class="event-details">
        <div class="eventphoto">
          <img class="eventphoto" src="$eventImage" alt="Event Logo">
        </div>
        <div class="event-details-content">
          <h3>Event Details:</h3>
          <p><strong>Event:</strong> ${widget.eventDoc!['event_name']}</p>
          
          <p><strong>Date:</strong> ${widget.eventDoc!['date']}</p>
         
          <p style="text-align: justify; font-size: 16px;"><strong>Description:</strong> ${widget.eventDoc!.get('description')}</p>
          
          <p><strong>Location:</strong> ${widget.eventDoc!['location']}</p>

          <p><strong>Price: ₹</strong> ${widget.eventDoc!['price']}</p>
        </div>
      </div>
      
      <p>For any questions or concerns, please contact us at support@keyplanner.app.</p>
      <p>We look forward to seeing you at the event!</p>
      <p> If you</p>
      
      <p>Best regards,</p>
      <p>The Key Planner Team</p>
    </div>
    <div class="footer">
      <p class="footer-text">© 2023 Key Planner. All rights reserved.</p>
    </div>
  </div>
</body>
</html>

""";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Error sending email: $e');
    }
  }

  void _showImagePopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Colors.transparent,
          insetAnimationDuration: SelectionOverlay.fadeDuration,
          backgroundColor:
              Colors.transparent, // Set the background to transparent.
          child: Stack(
            alignment: Alignment
                .topRight, // Align the close button to the top-right corner.
            children: [
              Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                height: MediaQuery.of(context).size.height *
                    0.8, // 80% of screen height
                child: Image.network(
                  eventImage,
                  fit: BoxFit.contain,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the dialog when the close button is pressed.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 27,
                      height: 27,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/circle.png'),
                        ),
                      ),
                      child: Image.asset('assets/bi_x-lg.png'),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: myText(
                        text: 'CheckOut',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: Color(0xff393939).withOpacity(0.15),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _showImagePopUp(context);
                        },
                        child: Image.network(
                          eventImage,
                          width:
                              150, // Set the initial width for the thumbnail image.
                          height:
                              150, // Set the initial height for the thumbnail image.
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 100,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(
                            eventImage,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width * 0.6,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.eventDoc!.get('event_name'),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                // myText(
                                //   text: widget.eventDoc!.get('event_name'),
                                //   style: TextStyle(
                                //     fontSize: 17,
                                //     fontWeight: FontWeight.w600,
                                //     color: AppColors.black,
                                //   ),
                                // ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 11.67,
                                height: 15,
                                child: Image.asset(
                                  'assets/location.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: Get.width * 0.5,
                                child: Flexible(
                                  child: myText(
                                    text: widget.eventDoc!.get('location'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          myText(
                            text: widget.eventDoc!.get('date'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blue,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          myText(
                            text: '\₹${widget.eventDoc!.get('price')}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              myText(
                text: "Payment Method",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 12,
                        child: Image.asset(
                          'assets/Group1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      myText(
                        text: 'Add Card detail',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Radio(
                    value: 0,
                    groupValue: selectedRadio,
                    onChanged: (int? val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ],
              ),
              textField(text: 'Card Number'),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: EdgeInsets.only(
                        bottom: Get.height * 0.02,
                      ),
                      child: TextFormField(
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Expiration date',
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.04,
                  ),
                  Expanded(child: textField(text: 'Security Code'))
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                children: [
                  myText(
                    text: 'Other option',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        setSelectedRadio(value!);
                      });
                    },
                    activeColor: AppColors.blue,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 48,
                    height: 34,
                    child: Image.asset(
                      'assets/paypal.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  myText(
                    text: 'Razorpay',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        setSelectedRadio(value!);
                      });
                    },
                    activeColor: AppColors.blue,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 48,
                    height: 34,
                    child: Image.asset(
                      'assets/strip.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  myText(
                    text: 'Stripe',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Radio(
                    value: 3,
                    groupValue: selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        setSelectedRadio(value!);
                      });
                    },
                    activeColor: AppColors.blue,
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  myText(
                    text: 'Event Fee',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '\₹${widget.eventDoc!.get('price')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  myText(
                    text: 'Total Ticket',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '\$${int.parse(widget.eventDoc!.get('price')) + 0}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: elevatedButton(
                  onpress: () {
                    if (selectedRadio == 3) {
                      makePayment(context,
                          amount:
                              '${int.parse(widget.eventDoc!.get('price')) + 2}',
                          eventId: widget.eventDoc!.id);
                    }
                    if (selectedRadio == 2) {
                      makepaymentWithRazorpay(
                          amount:
                              '${int.parse(widget.eventDoc!.get('price')) + 2}',
                          eventId: widget.eventDoc!.id);
                    }
                  },
                  text: 'Book Now',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners

    super.dispose();
  }
}

void joinEvent(String eventId) {
  FirebaseFirestore.instance.collection('events').doc(eventId).set(
    {
      'joined': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      'max_entries': FieldValue.increment(-1),
    },
    SetOptions(merge: true),
  ).then((value) {
    FirebaseFirestore.instance.collection('booking').doc(eventId).set({
      'booking': FieldValue.arrayUnion([
        {'uid': FirebaseAuth.instance.currentUser!.uid, 'tickets': 1}
      ])
    });
  }).catchError((error) {
    // Handle error if necessary
    print('Error joining event: $error');
  });
}
