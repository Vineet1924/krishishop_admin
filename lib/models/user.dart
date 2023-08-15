// ignore_for_file: camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  String? address;
  String? email;
  String? phone;
  String? profilepic;
  String? uid;
  String? username;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Admin");

  userModel(
      {required this.address,
      required this.email,
      required this.phone,
      required this.profilepic,
      required this.uid,
      required this.username,});

  Map<String, dynamic> addressMap() {
    return {"address": address};
  }

  Map<String, dynamic> emailMap() {
    return {"email": email};
  }

  Map<String, dynamic> phoneMap() {
    return {"phone": phone};
  }

  Map<String, dynamic> profilepicMap() {
    return {"profilepic": profilepic};
  }

  Map<String, dynamic> usernameMap() {
    return {"username": username};
  }

  Map<String, dynamic> uidMap() {
    return {"uid": uid};
  }

  Future<void> storeAddress() async {
    try {
      await usersCollection.doc(uid).set(addressMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeEmail() async {
    try {
      await usersCollection.doc(uid).set(emailMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storePhone() async {
    try {
      await usersCollection.doc(uid).set(phoneMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeProfilepic() async {
    try {
      await usersCollection
          .doc(uid)
          .set(profilepicMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeUsername() async {
    try {
      await usersCollection
          .doc(uid)
          .set(usernameMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeUid() async {
    try {
      await usersCollection.doc(uid).set(uidMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  factory userModel.fromMap(Map<String, dynamic> map) {
    return userModel(
        uid: map['uid'],
        address: map['address'],
        email: map['email'],
        phone: map['phone'],
        profilepic: map['profilepic'],
        username: map['username'],
        );
  }

  static Future<userModel?> loadFromFirestore(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Admin").doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userModel.fromMap(userData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error while loading data: $e");
    }
    return null;
  }
}
