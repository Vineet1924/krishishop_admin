// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_types_as_parameter_names, constant_identifier_names, unused_field, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishishop_admin/models/Order.dart';

class orderScreen extends StatefulWidget {
  const orderScreen({super.key});

  @override
  State<orderScreen> createState() => _orderScreenState();
}

class _orderScreenState extends State<orderScreen> {
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> orderStream;
  List<OrderModel> allOrder = [];
  List<OrderModel> displayedOrder = [];
  bool isEmpty = false;
  List<String> _items = ['Placed', 'Packed', 'Shipped', 'Delivered'];
  String _selectedItem = 'Placed';
  String orderId = "";

  @override
  void initState() {
    super.initState();
    fetchOrder().then((loadedOrder) {
      setState(() {
        allOrder = loadedOrder;
        displayedOrder = loadedOrder;
      });
    });
  }

  Future<List<OrderModel>> fetchOrder() async {
    List<OrderModel> orderList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("Orders").get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      OrderModel order = OrderModel.fromJson(doc);
      orderList.add(order);
    }
    return orderList;
  }

  void runSearch(String keyword) {
    List<OrderModel> result = [];

    if (keyword.isEmpty) {
      result = allOrder;
    } else {
      result = allOrder
          .where((OrderModel) =>
              OrderModel.email.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      displayedOrder = result;
      isEmpty = result.isEmpty;
    });
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  void showCupertino(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Update"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: DropdownButton<String>(
                      value: _selectedItem,
                      items: _items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (selectedItem) {
                        setState(() {
                          _selectedItem = selectedItem!;
                        });
                      },
                      hint: const Text('Select an item'),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                DateTime dateTime = DateTime.now();
                String newDate = formatDate(dateTime).toString();

                DocumentReference docRef = FirebaseFirestore.instance
                    .collection("Orders")
                    .doc(orderId);

                if (_selectedItem == "Packed") {
                  docRef.update({
                    'order_status': _selectedItem,
                    'packageDate': newDate,
                  });
                }

                if (_selectedItem == "Shipped") {
                  docRef.update({
                    'order_status': _selectedItem,
                    'shippmentDate': newDate,
                  });
                }

                if (_selectedItem == "Delivered") {
                  docRef.update({
                    'order_status': _selectedItem,
                    'deliveryDate': newDate,
                  });
                }

                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.grey.shade200,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (keyword) => runSearch(keyword),
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Search",
                  contentPadding: const EdgeInsets.all(12.0),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (!isEmpty)
            ListView.builder(
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: displayedOrder.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: ClipOval(
                            child: Image.network(
                                displayedOrder[index].imageLink,
                                fit: BoxFit.cover)),
                      ),
                      title: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            displayedOrder[index].email,
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          displayedOrder[index].address,
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          _selectedItem =
                              displayedOrder[index].order_status.toString();
                          orderId = displayedOrder[index].order_Id.toString();
                          showCupertino(context);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ));
                }),
          if (isEmpty)
            Text(
              "Result not found",
              style: TextStyle(fontSize: 40, color: Colors.grey.shade700),
            ),
        ],
      ),
    );
  }
}
