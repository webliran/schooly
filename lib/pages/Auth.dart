import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/login.provider.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final secCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              SizedBox(
                height: 50.00,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: secCode,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'שכחת להזין קוד';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'קוד אימות',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10.00,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            await loginProviderHolder
                                .verifyVerifaction(secCode.text);

                            if (loginProviderHolder.roles.length > 1) {
                              _showMaterialDialog(loginProviderHolder, context);
                            } else {
                              await loginProviderHolder.selectUser(
                                  loginProviderHolder.roles[0]['studentid']);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text(
                          'אימות',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    _isLoading ? LinearProgressIndicator() : SizedBox(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
