import 'package:flutter/material.dart';
import 'package:ubcfpv3/screen/home_screen.dart';
import 'package:ubcfpv3/screen/me_screen.dart';
import 'package:ubcfpv3/screen/user.dart';

User userInfo;



class ThankScreen extends StatefulWidget {
  @override
  _ThankScreenState createState() => _ThankScreenState();
}

class _ThankScreenState extends State<ThankScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
    );
  }
}
