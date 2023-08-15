// ignore_for_file: camel_case_types, use_build_context_synchronously, constant_identifier_names, non_constant_identifier_names

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
import 'package:krishishop_admin/dashboard.dart';
import 'package:krishishop_admin/models/Products.dart';

enum productType { Farming, Crops }

class updateScreen extends StatefulWidget {
  final Products product;
  const updateScreen({super.key, required this.product});

  @override
  State<updateScreen> createState() => _updateScreenState();
}

class _updateScreenState extends State<updateScreen> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> images = [];
  List<dynamic> ImageUrls = [];
  String name = "";
  String desc = "";
  String quantity = "";
  String price = "";
  String pid = "";
  productType? type;
  late String _type = "";

  @override
  void initState() {
    super.initState();

    pid = widget.product.pid;
    nameController.text = widget.product.name;
    descController.text = widget.product.description;
    quantityController.text = widget.product.quantity;
    priceController.text = widget.product.price;
    if (widget.product.type == "productType.Farming") {
      type = productType.Farming;
      _type = type.toString();
    } else {
      type = productType.Crops;
      _type.toString();
    }
    ImageUrls.addAll(widget.product.images);
  }

  String _generateUniqueImageName() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomString = Random().nextInt(10000).toString();
    return '$timestamp-$randomString';
  }

  Future<bool> removeFromStorage(List<dynamic> imageUrls) async {
    if (imageUrls.isNotEmpty) {
      EasyLoading.show(status: "Removing");
      for (var imageUrl in imageUrls) {
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(imageUrl);

        try {
          await storageReference.delete();
        } catch (error) {
          showErrorSnackBar(context, error.toString());
        }
      }

      try {
        await FirebaseFirestore.instance
            .collection("Products")
            .doc(pid)
            .update({"images": FieldValue.delete()});
      } catch (error) {
        showErrorSnackBar(context, error.toString());
      }

      setState(() {
        ImageUrls = [];
        EasyLoading.dismiss();
      });
      return true;
    }
    return false;
  }

  Future<bool> uploadToStorage(List<XFile> images) async {
    List<String> uploadUrls = [];
    if (images.isEmpty) {
      showErrorSnackBar(context, "Please select images");
      return false;
    }
    EasyLoading.show(status: "Updating");
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
      ImageUrls.addAll(uploadUrls);
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
            pid: pid,
            description: desc,
            name: name,
            quantity: quantity,
            images: ImageUrls,
            price: price,
            type: _type);

        await FirebaseFirestore.instance
            .collection("Products")
            .doc(pid)
            .update(products.toJson());

        EasyLoading.showSuccess("updated");
        return true;
      }
      return false;
    }

    setState(() {
      ImageUrls = [];
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
                          child: Container(
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
                        if (await removeFromStorage(ImageUrls)) {
                          if (await uploadToCollection()) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()));
                          }
                        }
                      },
                      title: "Update"),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          )
        ]));
  }
}
