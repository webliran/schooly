import 'package:flutter/material.dart';
import 'package:schooly/pages/WraperMain.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:provider/provider.dart';

class PopUpMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loginProviderHolder = context.watch<LoginProvider>();
    return PopupMenuButton(
        onSelected: (value) async {
          if (value == 2) {
            print(value);
            await loginProviderHolder.logout();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainWraper()),
            );
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[Text('הגדרות')],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[Text('התנתק')],
                  )),
            ]);
  }
}
