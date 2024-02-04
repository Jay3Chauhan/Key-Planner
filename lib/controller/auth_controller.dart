import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keypanner/utils/app_color.dart';
import 'package:keypanner/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:keypanner/views/onboarding_screen.dart';
import 'package:keypanner/views/profile/add_profile.dart';
import 'package:keypanner/views/profile/add_profilewithgoogle.dart';

//import '../views/bottom_nav_bar/bottom_bar_view.dart';
//import '../views/profile/add_profile.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  void login({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success

      isLoading(false);
      Get.to(() => BottomBarView());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occured
    });
  }

  void signUp({String? email, String? password}) {
    ///here we have to provide two things
    ///1- email
    ///2- password

    isLoading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.to(() => ProfileScreen());
    }).catchError((e) {
      /// print error information
      print("Error in authentication $e");
      isLoading(false);
    });
  }

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      print("Error in sending password reset email is $e");
    });
  }

  signInWithGoogle() async {
    isLoading(true);
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User userDetails = userCredential.user!;

      String _name = userDetails.displayName ?? '';
      String _email = userDetails.email ?? '';
      String _imageUrl = userDetails.photoURL ?? '';
      String _uid = userDetails.uid;

      bool _isLogin = true;
      String _providerisGoogle = "Google";
      String _providerisFacebook = "Facebook";

      // Check if user already exists in Firestore
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();

      if (userSnapshot.exists) {
        // User exists, retrieve data from Firestore
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _name = userData['first'] ?? _name;
        _email = userData['email'] ?? _email;
        _imageUrl = userData['image'] ?? _imageUrl;

        // Update the user's last login timestamp in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .update({'lastLogin': FieldValue.serverTimestamp()});
      } else {
        // User doesn't exist, create a new document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'image': _imageUrl,
          'first': _name,
          'email': _email,
          'provider': _providerisGoogle, // Set the provider (Google/Facebook)
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      isLoading(false);
      Get.snackbar("Welcome", "$_name");
      Get.to(() => ProfileScreenGoogle());
    } catch (e) {
      isLoading(false);
      print("Error is $e");
      Get.snackbar("Error", "Failed to sign in with Google");
    }
  }

  signupWithGoogle() async {
    isLoading(true);
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final User userDetails =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
    String? _name;
    String? _email;
    String? _imageUrl;
    String? _uid;
    bool _isLogin = false;
    String? _providerisGoogle;
    String? _providerisFacebook;
    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      isLoading(false);
      //SnackBar(content: Text("Welcome ${userDetails.displayName}"));
      Get.snackbar("Welcome", "${userDetails.displayName}");
      _name = userDetails.displayName;
      _email = userDetails.email;
      _imageUrl = userDetails.photoURL;
      _uid = userDetails.uid;
      _providerisGoogle = "Google";
      _providerisFacebook = "Facebook";
      _isLogin = true;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'image': _imageUrl,
        'first': _name,
      });

      /// cEHCKING VALUE IN PROGILE PAGE TO HERE

      ///SuccessFull loged in
      Get.to(() => ProfileScreen());
    }).catchError((e) {
      /// Error in getting Login
      isLoading(false);
      print("Error is $e");
    });
  }

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }

  uploadProfileData(String imageUrl, String username, String firstName,
      String lastName, String mobileNumber, String dob, String gender) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': imageUrl,
      'username': username,
      'first': firstName,
      'last': lastName,
      'dob': dob,
      'gender': gender,
      'mobile': mobileNumber,
      'uid': uid,
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(() => BottomBarView());
    });
  }

  Future<void> uploadReportData(
      String reportText, List<String> responses) async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final feedbackCollectionRef = FirebaseFirestore.instance
        .collection('feedbackreport')
        .doc(uid)
        .collection('Report');

    await feedbackCollectionRef.add({
      // 'feedback_text': reportText,
      'uid': uid,
      'responses': FieldValue.arrayUnion(responses),
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      isProfileInformationLoading(false);

      Get.offAll(() => BottomBarView());
      Get.snackbar(
        "Report",
        "Sent Successfully",
        // backgroundColor: Colors.blue,
        icon: Icon(
          Icons.check_circle_outline,
          color: AppColors.blue,
        ),
      );
    });
  }

  Future<void> uploadFeedbackData(
      String feedbacktext, List<String> responses) async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final feedbackCollectionRef = FirebaseFirestore.instance
        .collection('feedbackreport')
        .doc(uid)
        .collection('Feedback');

    await feedbackCollectionRef.add({
      // 'feedback_text': reportText,
      'uid': uid,
      'responses': FieldValue.arrayUnion(responses),
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      isProfileInformationLoading(false);

      Get.offAll(() => BottomBarView());
      Get.snackbar(
        "Feedback",
        "Sent Successfully",
        // backgroundColor: Colors.blue,
        icon: Icon(
          Icons.check_circle_outline,
          color: AppColors.blue,
        ),
      );
    });
  }
}

void signOut() {
  FirebaseAuth.instance.signOut();
  Get.offAll(() => OnBoardingScreen());
}
