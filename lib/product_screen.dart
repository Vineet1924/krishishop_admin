// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_types_as_parameter_names, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop_admin/add_product_screen.dart';
import 'package:krishishop_admin/components/my_card.dart';
import 'package:krishishop_admin/product_details.dart';
import 'models/Products.dart';

class product_screen extends StatefulWidget {
  const product_screen({super.key});

  @override
  State<product_screen> createState() => _product_screenState();
}

class _product_screenState extends State<product_screen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> productStream;

  @override
  void initState() {
    super.initState();
    productStream =
        FirebaseFirestore.instance.collection("Products").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: StreamBuilder(
              stream: productStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("inside waiting state");
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final documents = snapshot.data?.docs;

                  List<Products> products = documents!
                      .map((products) => Products(
                          description: products['description'],
                          name: products['name'],
                          quantity: products['quantity'],
                          images: products['images'],
                          price: products['price'],
                          pid: products.id,
                          type: products['type']))
                      .toList();

                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, Index) {
                        final product = products[Index];
                        EasyLoading.dismiss();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) =>
                                        productDetails(product: product))));
                          },
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                            ),
                            child: myCard(
                              index: Index,
                              name: products[Index].name,
                              description: products[Index].description,
                              quantity: products[Index].quantity,
                              price: products[Index].price,
                              image: products[Index].images[0],
                              product: products[Index],
                            ),
                          ),
                        );
                      });
                }
              })),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const add_product_screen()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
