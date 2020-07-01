import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/user.dart';
import 'package:projeto_integ/pages/collaboration/collaboration.dart';
import 'package:projeto_integ/pages/user.dart';
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
  String photoURL = "";
  User userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();

    await _db
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot document) {
      setState(() {
        name = document.data["name"];
        email = document.data["email"];
        firstChar = document.data["name"][0];
        photoURL = document.data["photoURL"];
        userModel = User.fromJson(document);
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
              backgroundImage: NetworkImage(photoURL),
              child: photoURL.isEmpty
                  ? Text(
                      firstChar,
                      style: TextStyle(fontSize: 40.0),
                    )
                  : Text(""),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Meus Dados'),
            onTap: () => {
              Navigator.push(
                  context,
                  Transition(
                      widget: UserPage(
                    userID: userModel.id,
                  )))
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Colaborações'),
            onTap: () => {
              Navigator.push(
                  context, Transition(widget: Collaboration(userModel.id)))
            },
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
