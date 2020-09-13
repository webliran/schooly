import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/homepage/MainLinksBox.dart';
import 'package:schooly/pages/AppSkelaton.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:schooly/providers/user.provider.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    var loginProviderHolder = context.watch<LoginProvider>();
    var userState = context.watch<UserProvider>();

    return MainAppSkelaton(
        MainLinksBox(), loginProviderHolder.selectedUser['schoolName']);
  }
}
