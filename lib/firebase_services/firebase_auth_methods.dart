// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../components/my_snackbar.dart';
import '../dashboard.dart';
import '../login_screen.dart';
import '../models/user.dart';

class FirebaseAuthMethods {
  final FirebaseAuth auth;
  FirebaseAuthMethods(this.auth);

  Future<void> signInWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      EasyLoading.show(status: "Signing in...");
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        userModel? loadUser = await userModel
            .loadFromFirestore(FirebaseAuth.instance.currentUser!.uid);

        if (loadUser?.uid == "") {
          showErrorSnackBar(context, "Email or password may be incorrect!");

          try {
            auth.signOut().then((value) async {
              await Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            });
          } on FirebaseAuthException catch (e) {
            showErrorSnackBar(context, e.code.toString());
          }
        } else {
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        }
        await EasyLoading.dismiss();
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          showErrorSnackBar(context, 'Password may be Incorrect!');
          await EasyLoading.dismiss();
          break;
        case 'user-not-found':
          showErrorSnackBar(context, 'Email may be Incorrect!');
          await EasyLoading.dismiss();
          break;
        case 'too-many-requests':
          showErrorSnackBar(
              context, 'Too many Wrong attempts! Try again latter');
          await EasyLoading.dismiss();
          break;
        case 'invalid-email':
          showErrorSnackBar(context, 'Invalid email format!');
          await EasyLoading.dismiss();
          break;
      }
    }
  }

  Future<void> logOut({required BuildContext context}) async {
    try {
      auth.signOut().then((value) async {
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      });
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.code);
    }
  }
}
