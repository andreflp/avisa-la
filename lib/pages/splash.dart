import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_integ/auth/rootpage.dart';
import 'package:projeto_integ/services/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService auth;
  VoidCallback loginCallback;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return RootPage(auth: Auth());
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Image.asset('images/logo.png')],
      ),
    );
  }
}
