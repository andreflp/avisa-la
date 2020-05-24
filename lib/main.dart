import 'package:flutter/material.dart';
import 'package:projeto_integ/pages/splash.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avisa lá',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
