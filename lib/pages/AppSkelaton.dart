import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/webview/WebViewHolder.dart';
import 'package:schooly/pages/home.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:schooly/providers/user.provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MainAppSkelaton extends StatefulWidget {
  MainAppSkelaton(this.child, this.title);
  final Widget child;
  final String title;
  @override
  _MainAppSkelatonState createState() => _MainAppSkelatonState();
}

class _MainAppSkelatonState extends State<MainAppSkelaton> {
  @override
  Widget build(BuildContext context) {
    var loginProviderHolder = context.watch<LoginProvider>();
    var userState = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await loginProviderHolder.logout();
            },
          ),
        ],
      ),
      body: widget.child,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            // Important: Remove any padding from the Column.
            children: <Widget>[
              DrawerHeader(
                child: Image.asset('assets/images/schooly-logo.png'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Column(
                // Important: Remove any padding from the Column.
                children: loginProviderHolder.selectedUser['resources']
                        ['sidebar_menu_buttons']
                    .map<Widget>((item) {
                  return ListTile(
                    leading: Container(
                        height: 20, child: Image.network(item['image'])),
                    title: Align(
                      child: Text(item['text']),
                      alignment: Alignment(1.2, 0),
                    ),
                    trailing: Text(item['type']),
                    onTap: () async {
                      if (item['type'] == "webview") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewHolder(
                                  item['type_data'], item['text'])),
                        );
                      } else {
                        if (item['type_data'] == "home") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => home()),
                          );
                        }
                      }
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
