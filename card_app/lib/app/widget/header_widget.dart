import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/header_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }
}
