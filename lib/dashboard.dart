// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop_admin/firebase_services/firebase_auth_methods.dart';
import 'package:krishishop_admin/order_screen.dart';
import 'package:krishishop_admin/product_screen.dart';
import 'package:krishishop_admin/profile_screen.dart';
import 'package:krishishop_admin/user_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
  }

  Future signOut() async {
    await EasyLoading.show(status: 'Loging out...');
    await FirebaseAuthMethods(FirebaseAuth.instance).logOut(context: context);
    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Krishishop",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
              indicatorWeight: 2,
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromARGB(255, 110, 190, 255),
              tabs: [
                Tab(
                  text: "Products",
                ),
                Tab(
                  text: "Users",
                ),
                Tab(
                  text: "Orders",
                ),
                Tab(
                  text: "Profile",
                ),
              ]),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: signOut,
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(
              child: product_screen(),
            ),
            Center(
              child: user_list(),
            ),
            Center(
              child: orderScreen(),
            ),
            Center(child: profileScreen()),
          ],
        ),
      ),
    );
  }
}
