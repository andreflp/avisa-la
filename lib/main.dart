import 'package:flutter/material.dart';
import 'package:projeto_integ/pages/login/login.dart';
import 'package:projeto_integ/pages/map.dart';
import 'package:projeto_integ/pages/splash.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projeto_integ/services/auth.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    VoidCallback logoutCallback;
    return MaterialApp(
      title: 'Avisa lá',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return PageTransition(
              child: SplashScreen(),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
            );
            break;
          case '/login':
            return PageTransition(
              child: Login(
                auth: Auth(),
              ),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
            );
            break;
          case '/map':
            return PageTransition(
              child: Maps(auth: Auth()),
              type: PageTransitionType.leftToRightWithFade,
              settings: settings,
            );
            break;
          default:
            return null;
        }
      },
      initialRoute: '/',
    );
  }
}
