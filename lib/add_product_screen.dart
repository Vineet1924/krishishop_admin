// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:krishishop_admin/components/my_button.dart';
import 'package:krishishop_admin/components/my_textfield.dart';

class add_product_screen extends StatefulWidget {
  const add_product_screen({super.key});

  @override
  State<add_product_screen> createState() => _add_product_screenState();
}

class _add_product_screenState extends State<add_product_screen> {
  List<String> items = ["Item-1", "Item-2", "Item-3"];

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();

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
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blue),
                              height: 200,
                              width: 200,
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    size: 70,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 200,
                            width: 200,
                            color: Colors.black,
                            margin: const EdgeInsets.all(3),
                            child: Image.asset("assets/images/google.png"),
                          );
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 220, left: 10, right: 10),
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
                  const SizedBox(
                    height: 40,
                  ),
                  MyButton(onTap: () {}, title: "Upload"),
                ]),
              ),
            ),
          )
        ]));
  }
}
