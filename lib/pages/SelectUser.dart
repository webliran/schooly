import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/login.provider.dart';

class SelectUser extends StatefulWidget {
  @override
  _SelectUserState createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  Widget icon;
  bool _isLoading = false;

  Widget getCardWidget(loginProviderHolder) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: loginProviderHolder.verifectionOptions.map<Widget>((item) {
        if (item['mode'] == "e") {
          icon = Icon(Icons.email);
        } else if (item['mode'] == "c") {
          icon = Icon(Icons.phone_android);
        }
        return Card(
            child: Directionality(
          textDirection: TextDirection.ltr,
          child: ListTile(
            leading: icon,
            title: Text(item['mask']),
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              await loginProviderHolder.sendVerifection(item['mask']);
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ));
      }).toList(),
    );
  }

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'יש לבחור שיטת אימות:',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              getCardWidget(loginProviderHolder),
              _isLoading ? LinearProgressIndicator() : SizedBox(),
            ],
          ),
        ),
      ),
    ]);
  }
}
