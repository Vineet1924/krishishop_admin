// ignore_for_file: camel_case_types, use_build_context_synchronously, constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishishop_admin/components/icon_tile.dart';
import 'package:krishishop_admin/components/my_button.dart';
import 'package:krishishop_admin/components/my_snackbar.dart';
import 'package:krishishop_admin/components/my_textfield.dart';
import 'package:krishishop_admin/models/Products.dart';

enum productType { Farming, Crops }

class add_product_screen extends StatefulWidget {
  const add_product_screen({super.key});

  @override
  State<add_product_screen> createState() => _add_product_screenState();
}

class _add_product_screenState extends State<add_product_screen> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageUrls = [];
  String name = "";
  String desc = "";
  String quantity = "";
  String price = "";
  productType? type;
  late String _type = "";

  String _generateUniqueImageName() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomString = Random().nextInt(10000).toString();
    return '$timestamp-$randomString';
  }

  Future<bool> uploadToStorage(List<XFile> images) async {
    List<String> uploadUrls = [];
    if (images.isEmpty) {
      showErrorSnackBar(context, "Please select images");
      return false;
    }
    EasyLoading.show(status: "Uploading");
    final root = FirebaseStorage.instance.ref();
    final products = root.child("products");
    for (var image in images) {
      try {
        String uniqueName = _generateUniqueImageName();
        final imageToUpload = products.child(uniqueName);
        await imageToUpload.putFile(File(image.path));
        final imageUrl = await imageToUpload.getDownloadURL();
        uploadUrls.add(imageUrl.toString());
      } catch (error) {
        showErrorSnackBar(context, error.toString());
      }
    }

    setState(() {
      imageUrls.addAll(uploadUrls);
    });
    return true;
  }

  Future<bool> validateData(String name, String desc, String price,
      String quantity, String type) async {
    if (name == "") {
      showErrorSnackBar(context, "Enter name of product");
      return false;
    } else if (desc == "") {
      showErrorSnackBar(context, "Enter description of product");
      return false;
    } else if (quantity == "") {
      showErrorSnackBar(context, "Enter quantity of product");
      return false;
    } else if (price == "") {
      showErrorSnackBar(context, "Enter price of product");
      return false;
    } else if (type == "") {
      showErrorSnackBar(context, "Select product type");
      return false;
    } else {
      return true;
    }
  }

  Future<bool> uploadToCollection() async {
    name = nameController.text;
    desc = descController.text;
    price = priceController.text;
    quantity = quantityController.text;

    bool isValid = await validateData(name, desc, price, quantity, _type);

    if (isValid) {
      bool isUploaded = await uploadToStorage(images);

      if (isUploaded) {
        Products products = Products(
            pid: "",
            description: desc,
            name: name,
            quantity: quantity,
            images: imageUrls,
            price: price,
            type: _type);

        var docRef = await FirebaseFirestore.instance
            .collection("Products")
            .add(products.toJson());

        String newId = docRef.id;
        products.copyPid(newId.toString());
        await docRef.update({'pid': newId.toString()});

        EasyLoading.showSuccess("uploaded");
        return true;
      }
      return false;
    }

    setState(() {
      imageUrls = [];
    });
    return false;
  }

  Future<void> selectedImages() async {
    List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isEmpty) {
      showErrorSnackBar(context, "No image selected");
    }

    setState(() {
      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages);
      }
    });
  }

  void removeImage(var index) {
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Krishishop",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          SizedBox(
              height: 200,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          removeImage(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container (
                            height: 20,
                            width: 200,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
                            margin: const EdgeInsets.all(3),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 210, left: 15, right: 15),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 70,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MyTextField(
                      controller: nameController,
                      hintText: "name",
                      obscureText: false,
                      inputType: TextInputType.text,
                      isEditable: true),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: descController,
                      hintText: "Description",
                      obscureText: false,
                      inputType: TextInputType.text,
                      isEditable: true),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: quantityController,
                      hintText: "Quantity",
                      obscureText: false,
                      inputType: TextInputType.number,
                      isEditable: true),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: priceController,
                      hintText: "Price",
                      obscureText: false,
                      inputType: TextInputType.number,
                      isEditable: true),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: RadioListTile<productType>(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  title: Text(
                                    "Crops",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  value: productType.Farming,
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = val;
                                      _type = val.toString();
                                    });
                                  })),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RadioListTile<productType>(
                                    contentPadding: const EdgeInsets.all(0.0),
                                    title: Text(
                                      "Farming",
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                    value: productType.Crops,
                                    groupValue: type,
                                    onChanged: (val) {
                                      setState(() {
                                        type = val;
                                        _type = val.toString();
                                      });
                                    })),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () async {
                        await selectedImages();
                      },
                      child: const iconTile(
                          icon: Icon(Icons.file_upload_outlined))),
                  const SizedBox(
                    height: 30,
                  ),
                  MyButton(
                      onTap: () async {
                        if (await uploadToCollection()) {
                          Navigator.pop(context, true);
                          EasyLoading.dismiss();
                        }
                      },
                      title: "Upload"),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          )
        ]));
  }
}
