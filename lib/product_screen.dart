// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:krishishop_admin/add_product_screen.dart';

class product_screen extends StatefulWidget {
  const product_screen({super.key});

  @override
  State<product_screen> createState() => _product_screenState();
}

class _product_screenState extends State<product_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
