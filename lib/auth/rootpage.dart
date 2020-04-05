import 'package:flutter/material.dart';
import 'package:projeto_integ/pages/login/login.dart';
import 'package:projeto_integ/pages/map.dart';
import 'package:projeto_integ/services/auth.dart';
import 'package:page_transition/page_transition.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_AUTHENTICATED,
  AUTHENTICATED,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final AuthService auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus = user?.uid == null
            ? AuthStatus.NOT_AUTHENTICATED
            : AuthStatus.AUTHENTICATED;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.AUTHENTICATED;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_AUTHENTICATED;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_AUTHENTICATED:
        return Login(auth: widget.auth, loginCallback: loginCallback);
        break;
      case AuthStatus.AUTHENTICATED:
        if (_userId.length > 0 && _userId != null) {
          return Maps(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
