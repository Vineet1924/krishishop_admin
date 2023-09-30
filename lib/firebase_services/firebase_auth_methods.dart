// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/my_snackbar.dart';
import '../dashboard.dart';
import '../login_screen.dart';
import '../models/user.dart';

class FirebaseAuthMethods {
  final FirebaseAuth auth;
  FirebaseAuthMethods(this.auth);

  Future<void> signUpWithEmail(
      {required email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await EasyLoading.showSuccess('Account Created!');

        var firebaseUser = await auth.currentUser!;
        var uid = firebaseUser.uid;
        final userData = {"uid": uid, "email": email, "address":"", "phone": "", "profilepic": "", "username": ""};
        await FirebaseFirestore.instance
            .collection("Admin")
            .doc(uid)
            .set(userData);

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Dashboard()));
      });
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          showErrorSnackBar(context, 'Invalid email format!');
          break;
        case 'weak-password':
          showErrorSnackBar(context, 'Select strong Password!');
          break;
        case 'email-already-in-use':
          showErrorSnackBar(context, 'email is already registerd!');
          break;
      }
    }
  }

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

  signInWithGoogle(BuildContext context) async {
    await EasyLoading.show(status: 'Loging in');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    
    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = await authResult.user;
    var firebaseUser = await auth.currentUser!;

    var uid = firebaseUser.uid;
    final userData = {"uid": uid, "email": user?.email, "phone":"", "address":"", "profilepic":"", "username" : ""};
    await FirebaseFirestore.instance
        .collection("Admin")
        .doc(uid)
        .set(userData, SetOptions(merge: true));

    return await FirebaseAuth.instance.signInWithCredential(credential);
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
