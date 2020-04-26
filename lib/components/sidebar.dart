import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_integ/services/auth.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer(this.auth, this.context);

  final AuthService auth;
  final BuildContext context;

  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  FirebaseUser currentUser;
  AuthService auth;
  String name = "";
  String email = "";
  String firstChar = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    print(user.uid);

    await _db
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot payload) {
      setState(() {
        name = payload.data["name"];
        email = payload.data["email"];
        firstChar = payload.data["name"][0];
        print(firstChar);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                firstChar,
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Meus Dados'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Colaborações'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () => _signOut(),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }
}
