// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String order_Id;
  String user_Id;
  String totalAmount;
  String orderDate;
  String packageDate;
  String shippmentDate;
  String deliveryDate;
  List<dynamic> items;
  String order_status;
  String email;
  String imageLink;
  String address;
  String customerName;

  OrderModel({
    required this.order_Id,
    required this.user_Id,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
    required this.order_status,
    required this.email,
    required this.imageLink,
    required this.address,
    required this.packageDate,
    required this.deliveryDate,
    required this.shippmentDate,
    required this.customerName,
  });

  factory OrderModel.fromJson(DocumentSnapshot json) => OrderModel(
      order_Id: json["order_Id"],
      user_Id: json["user_Id"],
      customerName: json["customerName"],
      totalAmount: json["totalAmount"],
      orderDate: json["orderDate"],
      items: List<dynamic>.from(json["items"].map((x) => x)),
      order_status: json["order_status"],
      email: json["email"],
      imageLink: json["imageLink"],
      address: json["address"],
      packageDate: json["packageDate"],
      deliveryDate: json["deliveryDate"],
      shippmentDate: json["shippmentDate"]);

  Map<String, dynamic> toJson() => {
        "order_Id": order_Id,
        "user_Id": user_Id,
        "totalAmount": totalAmount,
        "orderDate": orderDate,
        "items": List<dynamic>.from(items.map((x) => x)),
        "order_status": order_status,
        "email": email,
        "imageLink": imageLink,
        "address": address,
        "packageDate": packageDate,
        "deliveryDate": deliveryDate,
        "shippmentDate": shippmentDate,
        "customerName": customerName,
      };
}
