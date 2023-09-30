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
      body: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: double.infinity,
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
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.name,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "₹ ${widget.price}",
                  style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
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
        ),
      ),
    );
  }
}
