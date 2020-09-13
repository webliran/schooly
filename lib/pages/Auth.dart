import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/login.provider.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingModal = false;
  Widget jobTitle;
  Widget icon;

  _showMaterialDialog(loginProviderHolder, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        print(_isLoadingModal);
        return AlertDialog(
          title: Text(
            'אנא בחר תפקידך',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: loginProviderHolder.roles.map<Widget>((item) {
                    print(item['isTeacher']);
                    if (item['isTeacher'] == 2) {
                      icon = Icon(Icons.group);
                      jobTitle = Text("הורה");
                    } else if (item['isTeacher'] == 1) {
                      icon = Icon(Icons.local_library);
                      jobTitle = Text("מורה");
                    } else if (item['isTeacher'] == 0) {
                      icon = Icon(Icons.face);
                      jobTitle = Text("תלמיד");
                    }
                    return Card(
                      child: ListTile(
                        leading: icon,
                        trailing: jobTitle,
                        title: Text(item['schoolName']),
                        onTap: () async {
                          setState(() {
                            _isLoadingModal = true;
                          });
                          await loginProviderHolder
                              .selectUser(item['studentid']);
                          Navigator.pop(context);
                          setState(() {
                            _isLoadingModal = false;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                _isLoadingModal ? LinearProgressIndicator() : SizedBox(),
              ],
            ),
          ),
        );
      }),
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
            children: <Widget>[
              Text(
                'קוד אימות',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              SizedBox(
                height: 50.00,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    dialogConfig: DialogConfig(
                        affirmativeText: "הדבק",
                        negativeText: "ביטול",
                        dialogContent: "אתה רוצה להדביק את קוד האימות ",
                        dialogTitle: "קוד אימות"),
                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    backgroundColor: Colors.transparent,
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: Colors.white,
                        inactiveColor: Colors.yellow[100]),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: false,
                    onCompleted: (v) async {
                      setState(() {
                        _isLoading = true;
                      });

                      await loginProviderHolder.verifyVerifaction(v);

                      if (loginProviderHolder.roles.length > 0) {
                        _showMaterialDialog(loginProviderHolder, context);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    onChanged: (v) {
                      //print(value);
                      //loginProviderHolder.verifyVerifaction(v);
                    },
                    beforeTextPaste: (text) {
                      //print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  loginProviderHolder.loginUser(loginProviderHolder.userId);
                },
                child: Text(
                  "לא הגיע? שלח שוב",
                ),
              ),
              _isLoading ? LinearProgressIndicator() : SizedBox(),
            ],
          ),
        ),
      ),
    ]);
  }
}
