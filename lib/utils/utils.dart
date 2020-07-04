import 'package:flutter/material.dart';

final hintText = TextStyle(
  color: Colors.white54,
);

final boxDecoration = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

occurrenceFieldDecoration(String hintText, IconData icon, String labelText) {
  return InputDecoration(
      counterText: ' ',
      hintText: hintText,
      labelText: labelText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: Icon(icon));
}

loginFieldDecoration(String hint, IconData icon) {
  return InputDecoration(
    counterText: ' ',
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
//              contentPadding:
//                  EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
    prefixIcon: Icon(
      icon,
      color: Colors.white,
    ),
    hintText: hint,
    hintStyle: hintText,
  );
}
