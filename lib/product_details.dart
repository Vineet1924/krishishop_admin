// ignore_for_file: must_be_immutable, camel_case_types, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop_admin/dashboard.dart';
import 'package:krishishop_admin/update_screen.dart';
import 'components/my_snackbar.dart';
import 'models/Products.dart';

class productDetails extends StatefulWidget {
  final Products product;

  const productDetails({super.key, required this.product});

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  List<dynamic> images = [];
  String name = "";
  String description = "";
  String quantity = "";
  String price = "";
  String pid = "";

  @override
  void initState() {
    super.initState();
    images.addAll(widget.product.images);
    name = widget.product.name;
    description = widget.product.description;
    quantity = widget.product.quantity;
    price = widget.product.price;
    pid = widget.product.pid;
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

      setState(() {
        images = [];
      });
      return true;
    }
    return false;
  }

  Future<void> removeDocument() async {
    await removeFromStorage(images);
    await FirebaseFirestore.instance.collection("Products").doc(pid).delete();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 340,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView.builder(
              itemCount: images.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    height: 340,
                    width: 380,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
        ),
        Positioned(
          top: 330,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 388,
              height: 425,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹ $price",
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      quantity == "0"
                          ? const Text(
                              "Out of Stock",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 32,
                              ),
                            )
                          : Text(
                              quantity,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 32,
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 780,
          child: Container(
            height: 120,
            width: 413,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 20, right: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          (MaterialPageRoute(
                              builder: (context) =>
                                  updateScreen(product: widget.product))));
                    },
                    child: Container(
                      width: 240,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Center(
                          child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 8, right: 8),
                  child: GestureDetector(
                    onTap: () async {
                      await removeDocument();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()));
                    },
                    child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 167, 167),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Center(
                          child: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 255, 24, 8),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 785,
          left: 178,
          child: Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100)),
          ),
        )
      ],
    );
  }
}
