import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/login.provider.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() {
    return _LoaderState();
  }
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    var loginProviderHolder = context.watch<LoginProvider>();

    return Stack(children: <Widget>[
      Image.asset(
        'assets/images/black.jpg',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Container(
        padding: new EdgeInsets.all(20.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      await loginProviderHolder.logout();
                    },
                  ),
                  CircularProgressIndicator()
                ]),
          ),
        ),
      ),
    ]);
  }
}
