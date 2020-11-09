import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/pages/Auth.dart';
import 'package:schooly/pages/Loader.dart';
import 'package:schooly/pages/Login.dart';
import 'package:schooly/pages/home.dart';
import 'package:schooly/pages/SelectUser.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/providers/user.provider.dart';

class MainWraper extends StatefulWidget {
  @override
  _MainWraperState createState() => _MainWraperState();
}

class _MainWraperState extends State<MainWraper> {
  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginProvider>();

    switch (loginState.step) {
      case "offline":
        {
          return Login();
        }
        break;

      case "select_verifection_option":
        {
          return SelectUser();
        }
        break;
      case "auth":
        {
          return Auth();
        }
        break;
      case "logedin":
        {
          return home();
        }
        break;
      default:
        {
          return Loader();
        }
        break;
    }
  }
}
