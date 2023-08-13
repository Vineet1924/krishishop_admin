// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class iconTile extends StatelessWidget {
  final Icon icon;

  const iconTile({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: icon);
  }
}
