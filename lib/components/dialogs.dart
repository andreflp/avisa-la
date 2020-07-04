import 'package:flutter/material.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/pages/collaboration/collaboration.dart';
import 'package:projeto_integ/pages/map/map.dart';

Future showSuccessDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Salvo com sucesso!",
              style: TextStyle(color: Colors.green),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      icon: Icon(
                        Icons.check,
                        size: 18.0,
                      ),
                      textColor: Colors.white,
                      color: Colors.green,
                      label: Text(""),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          Transition(widget: Maps()),
                        );
                      },
                    ))
              ],
            ),
          ),
        );
      });
}

Future showRemoveSuccessDialog(
    BuildContext context, String id, CollaborationWidget collaboration) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Removido com sucesso!",
              style: TextStyle(color: Colors.green),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      icon: Icon(
                        Icons.check,
                        size: 18.0,
                      ),
                      textColor: Colors.white,
                      color: Colors.green,
                      label: Text(""),
                      onPressed: () {
                        Navigator.pop(context);
                        collaboration.setState(() {});
                      },
                    ))
              ],
            ),
          ),
        );
      });
}

Future showErrorDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Ops! Aconteceu algum erro.",
              style: TextStyle(color: Colors.red),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      icon: Icon(
                        Icons.check,
                        size: 18.0,
                      ),
                      textColor: Colors.white,
                      color: Colors.green,
                      label: Text(""),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          Transition(widget: Maps()),
                        );
                      },
                    ))
              ],
            ),
          ),
        );
      });
}
