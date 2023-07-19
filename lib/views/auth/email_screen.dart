import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keypanner/utils/app_constants.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (!_user!.emailVerified) {
      _sendVerificationEmail();
    }
  }

  Future<void> _sendVerificationEmail() async {
    await _user!.sendEmailVerification();
  }

  Future<void> _updateVerificationStatus(bool isVerified) async {
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .update({'emailVerified': isVerified});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _user!.emailVerified
                  ? 'Email is verified.'
                  : 'Email is not verified.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _user!.reload();
                if (_user!.emailVerified) {
                  _updateVerificationStatus(true);
                } else {
                  _updateVerificationStatus(false);
                }
              },
              child: Text('Refresh Verification Status'),
            ),
          ],
        ),
      ),
    );
  }
}
