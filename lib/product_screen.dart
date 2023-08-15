// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_types_as_parameter_names, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<Products> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var documents =
        await FirebaseFirestore.instance.collection("Products").get();
    mapProducts(documents);
  }

  mapProducts(QuerySnapshot<Map<String, dynamic>> documents) {
    var productsList = documents.docs
        .map(
          (products) => Products(
              pid: products.id,
              description: products['description'],
              name: products['name'],
              quantity: products['quantity'],
              images: products['images'],
              price: products['price'],
              type: products['type']),
        )
        .toList();

    setState(() {
      products = productsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, Index) {
              final product = products[Index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (context) =>
                              productDetails(product: product))));
                },
                child: Material(
                  elevation: 4,
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: myCard(
                      product: product,
                      index: Index,
                      name: products[Index].name,
                      description: products[Index].description,
                      quantity: products[Index].quantity,
                      price: products[Index].price,
                      image: products[Index].images[0],
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () async {
            final shouldReferesh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const add_product_screen()));

            if (shouldReferesh == true) {
              await fetchProducts();
            }
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
