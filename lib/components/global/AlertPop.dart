import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, title, content, okFn, isDoubleClose) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("ביטול"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("אישור"),
    onPressed: () async {
      okFn();
      Navigator.pop(context);
      if (isDoubleClose) {
        Navigator.pop(context);
      }
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
