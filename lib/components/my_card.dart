// ignore_for_file: camel_case_types, must_be_immutable, recursive_getters
import 'package:flutter/material.dart';

class myCard extends StatefulWidget {
  int index;
  String name = "";
  String description = "";
  String quantity = "";
  String price = "";
  String image = "";
  myCard(
      {super.key,
      required this.index,
      required this.name,
      required this.description,
      required this.quantity,
      required this.price,
      required this.image});

  @override
  State<myCard> createState() => _myCardState();
}

class _myCardState extends State<myCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: widget.index,
        onPressed: () {},
        mini: true,
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
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
            child: Text(
              widget.quantity,
              style: TextStyle(color: Colors.green.shade800, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
