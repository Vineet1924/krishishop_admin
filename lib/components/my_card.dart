// ignore_for_file: camel_case_types, must_be_immutable, recursive_getters, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:krishishop_admin/update_screen.dart';

import '../models/Products.dart';

class myCard extends StatefulWidget {
  int index;
  String name = "";
  String description = "";
  String quantity = "";
  String price = "";
  String image = "";
  final Products product;
  myCard(
      {super.key,
      required this.index,
      required this.name,
      required this.description,
      required this.quantity,
      required this.price,
      required this.image,
      required this.product});

  @override
  State<myCard> createState() => _myCardState();
}

class _myCardState extends State<myCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: widget.index,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => updateScreen(
                        product: widget.product,
                      )));
        },
        mini: true,
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.name,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "₹ ${widget.price}",
              style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: widget.quantity == "0"
                ? const Text(
                    "Out of Stock",
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  )
                : Text(
                    widget.quantity,
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
