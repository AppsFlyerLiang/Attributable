import 'package:flutter/material.dart';

class CustomerUserId extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      child: TextField(
        controller: TextEditingController(),
      ),
    ));
  }
}
