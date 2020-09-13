import 'package:flutter/foundation.dart';
import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';

class UserProvider extends SchoolyApi with ChangeNotifier {
  var selectedUser;

  void user(selectedUserInfo) {
    selectedUser = selectedUserInfo[0];
    //print(selectedUserInfo[0]['studentid']);
    notifyListeners();
  }

  @override
  String toString() {
    return 'user: $selectedUser';
  }
}
