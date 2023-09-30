// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krishishop_admin/models/user.dart';

class user_list extends StatefulWidget {
  const user_list({super.key});

  @override
  State<user_list> createState() => _user_listState();
}

class _user_listState extends State<user_list> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;

  @override
  void initState() {
    super.initState();

    userStream = FirebaseFirestore.instance.collection("Users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
            } else if (snapshot.hasError) {
              return const Text("");
            } else {
              final documents = snapshot.data?.docs;
              List<userModel>? users = documents!
                  .map((user) => userModel(
                      address: user['address'] ?? '',
                      email: user['email'] ?? '',
                      phone: user['phone'] ?? '',
                      profilepic: user['profilepic'] ?? '',
                      uid: user['uid'] ?? '',
                      username: user['username'] ?? ''))
                  .toList();

              return ListView.builder(
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: users[index].profilepic == ''
                          ? ClipOval(
                              child: Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                users[index].profilepic.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        users[index].username.toString(),
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        users[index].email.toString(),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.location_history,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
