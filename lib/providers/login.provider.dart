import 'package:flutter/foundation.dart';
import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';
import 'package:schooly/providers/user.provider.dart';

class LoginProvider extends SchoolyApi with ChangeNotifier {
  String step = 'loading';
  String msg = '';
  String userId;
  String mask;
  String mode;
  List verifectionOptions = [];
  List roles = [];
  String studentId;
  var selectedUser;

  @override
  String toString() {
    return 'step : $step';
  }

  LoginProvider() {
    isLogedIn();
  }

  void showWebColoredToast() {
    var msgTrans = Translate().translations[msg] != null
        ? Translate().translations[msg]
        : msg;
    Fluttertoast.showToast(
      msg: msgTrans,
      toastLength: Toast.LENGTH_LONG,
      webBgColor: "#e74c3c",
      timeInSecForIosWeb: 5,
    );
  }

  void getRoles() async {
    String uuid = await SharedState().read("uuid");
    var response = await http.get('$url/?query=GetUsers&uuid=$uuid');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['success']) {
        roles = jsonResponse['data'];
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  void logout() async {
    await SharedState().remove("uuid");
    await SharedState().remove("studentId");
    roles = [];
    step = 'offline';
    notifyListeners();
  }

  void isLogedIn() async {
    var uuid = await SharedState().check('uuid');
    var studentId = await SharedState().check('studentId');

    if (!studentId || !uuid) {
      step = 'offline';
      notifyListeners();
    } else {
      await selectUser(null);
    }
  }

  selectUser(studentId) async {
    String uuid = await SharedState().read("uuid");
    if (studentId == null) {
      studentId = await SharedState().read("studentId");
    } else {
      await SharedState().save("studentId", studentId.toString());
    }
    print('$url/?query=SelectUser&uuid=$uuid&studentid=$studentId');
    var response = await http
        .get('$url/?query=SelectUser&uuid=$uuid&studentid=$studentId');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['success']) {
        selectedUser = jsonResponse['data']
            .where((item) => item['is_selected'].toString() == 'true')
            .toList()[0];

        step = "logedin";
      } else {
        msg = jsonResponse['Msg'];
        showWebColoredToast();
        logout();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    notifyListeners();
  }

  void verifyVerifaction(String vcode) async {
    String uuid = await SharedState().read("uuid");

    var response = await http.get(
        '$url/?query=UserLogin&username=$userId&uuid=$uuid&mask=$mask&vcode=$vcode');

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['success']) {
        studentId = jsonResponse['studentId'];
        await getRoles();
      } else {
        msg = 'ValidationError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    notifyListeners();
  }

  void sendVerifection([String mask]) async {
    String currentMask = mask != "" ? mask : mask;
    var response = await http
        .get('$url/?query=UserLogin&username=$userId&mask=$currentMask');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['success']) {
        await SharedState().save("uuid", jsonResponse['uuid']);
        step = 'auth';
      } else {
        msg = 'SendValidationError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }

    notifyListeners();
  }

  void loginUser(String id) async {
    userId = id;
    var response = await http.get('$url/?query=UserLogin&username=$userId');

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['success']) {
        if (jsonResponse['data'].length > 1) {
          step = 'select_verifection_option';
          verifectionOptions = jsonResponse['data'];
        } else {
          mode = jsonResponse['data'][0]['mode'];
          mask = jsonResponse['data'][0]['mask'];
          sendVerifection();
        }
      } else {
        msg = jsonResponse['Msg'];
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    notifyListeners();
  }
}
