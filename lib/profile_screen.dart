// ignore_for_file: camel_case_types, use_build_context_synchronously, avoid_print, await_only_futures, unnecessary_string_interpolations, avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishishop_admin/components/icon_tile.dart';
import 'package:krishishop_admin/components/my_snackbar.dart';
import 'package:krishishop_admin/models/user.dart';
import 'components/my_textfield.dart';
import 'firebase_services/firebase_auth_methods.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  User? auth = FirebaseAuth.instance.currentUser;
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool isEditable = false;
  String imageLink = "";
  String? address = "";
  String? phone = "";
  String? username = "";

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  Future signOut() async {
    await EasyLoading.show(status: 'Loging out...');
    await FirebaseAuthMethods(FirebaseAuth.instance).logOut(context: context);
    await EasyLoading.dismiss();
  }

  Future<void> loadUser() async {
    userModel? loadUser = await userModel.getUserData(auth!.uid);

    setState(() {
      if (loadUser.profilepic != null) {
        imageLink = loadUser.profilepic!;
      } else {
        imageLink = "";
      }

      username = loadUser.username;
      address = loadUser.address;
      phone = loadUser.phone;

      print(username);
      print(address);
      print(phone);

      usernameController.text = username ?? 'Username';
      addressController.text = address ?? 'Address';
      phoneController.text = phone ?? 'Phone';
    });
  }

  void showCupertino(BuildContext context) {
    final usernameCupertino = TextEditingController();
    final phoneCupertino = TextEditingController();
    final addressCupertino = TextEditingController();

    usernameCupertino.text = username ?? 'Username';
    addressCupertino.text = address ?? 'Address';
    phoneCupertino.text = phone ?? 'Phone';

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text("Update"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: usernameCupertino,
                      hintText: "Username",
                      obscureText: false,
                      inputType: TextInputType.text,
                      isEditable: true),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: addressCupertino,
                      hintText: "Address",
                      obscureText: false,
                      inputType: TextInputType.text,
                      isEditable: true),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: phoneCupertino,
                      hintText: "Phone",
                      obscureText: false,
                      inputType: TextInputType.phone,
                      isEditable: true),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () async {
                    EasyLoading.show(status: "Updating");
                    User? auth = await FirebaseAuth.instance.currentUser;
                    String? uid = auth!.uid;
                    String? email = auth.email;

                    username = usernameCupertino.text;
                    address = addressCupertino.text;
                    phone = phoneCupertino.text;

                    if (phone?.length != 10) {
                      EasyLoading.dismiss();
                      showErrorSnackBar(context, "Enter valid phone number");
                      Navigator.of(context).pop();
                      return;
                    }

                    userModel storeUser = userModel(
                        address: address,
                        email: email,
                        phone: phone,
                        profilepic: imageLink,
                        uid: uid,
                        username: username);

                    await storeUser.storeAddress();
                    await storeUser.storeUsername();
                    await storeUser.storePhone();
                    await storeUser.storeEmail();
                    await storeUser.storeUid();
                    EasyLoading.showSuccess("Updated");
                    EasyLoading.dismiss();
                    Navigator.of(context).pop();

                    setState(() {
                      loadUser();
                    });
                  },
                  child: const Text("Update"),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                )
              ],
            ));
  }

  void showCupertinoImage(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text("Choose"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: const iconTile(icon: Icon(Icons.camera_alt)),
                          onTap: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? image = await imagePicker.pickImage(
                                source: ImageSource.camera);

                            if (image == null) {
                              showErrorSnackBar(context, "No image selected");
                            } else {
                              print("${image.path}");
                              print("${image.name}");
                              addImageInStorage(image);
                            }
                          }),
                      const SizedBox(width: 30),
                      GestureDetector(
                        child: const iconTile(
                            icon: Icon(Icons.file_upload_outlined)),
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          if (image == null) {
                            showErrorSnackBar(context, "No image selected");
                          } else {
                            print("${image.path}");
                            print("${image.name}");
                            addImageInStorage(image);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                )
              ],
            ));
  }

  Future<void> addImageInCollection(String imageLink) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("Admin");
    try {
      final user = FirebaseAuth.instance.currentUser;
      var profilepicMap = {
        "profilepic": imageLink,
      };
      await collectionReference
          .doc(user?.uid)
          .set(profilepicMap, SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> addImageInStorage(XFile? image) async {
    Reference root = FirebaseStorage.instance.ref();
    Reference profile = root.child("profile");
    Reference imageToUpload = profile.child("${image!.name}");
    try {
      EasyLoading.show(status: "Uploading");
      await imageToUpload.putFile(File(image.path));
      EasyLoading.showSuccess("Uploaded");
      imageLink = await imageToUpload.getDownloadURL();
      await addImageInCollection(imageLink);
      EasyLoading.dismiss();
      Navigator.of(context).pop();

      setState(() {
        loadUser();
      });
    } on Exception catch (e) {
      showErrorSnackBar(context, "Error while uploading $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 270,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                      color: Colors.white, width: 4)),
                              child: ClipOval(
                                child: Image.network(
                                  imageLink,
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/user.png', // Local placeholder image
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          showCupertinoImage(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      username != null && username!.isNotEmpty
                          ? username!
                          : 'Username',
                      style:
                          TextStyle(fontSize: 24, color: Colors.grey.shade100),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: usernameController,
                            hintText: "Username",
                            obscureText: false,
                            inputType: TextInputType.text,
                            isEditable: isEditable,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: addressController,
                            hintText: "Address",
                            obscureText: false,
                            inputType: TextInputType.text,
                            isEditable: isEditable,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: phoneController,
                            hintText: "Phone",
                            obscureText: false,
                            inputType: TextInputType.number,
                            isEditable: isEditable,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: GestureDetector(
                              child: const iconTile(icon: Icon(Icons.edit)),
                              onTap: () {
                                showCupertino(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: GestureDetector(
                              child: iconTile(icon: Icon(Icons.logout)),
                              onTap: signOut,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
