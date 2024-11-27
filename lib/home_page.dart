import 'package:flutter/material.dart';
import 'package:foodapp/typography.dart';

import 'color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'benzy',
                style: FontClass.appBar.copyWith(color: Colors.black),
              ),
              TextSpan(
                text: 'food',
                style: TextStyle(
                  fontFamily: FONT_FAMILY,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: myPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: myOnSecondaryColor,
      ),
      body: SafeArea(child:
      Container(

      )),
    );
  }
}
