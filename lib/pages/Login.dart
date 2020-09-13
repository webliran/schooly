import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/login.provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final idNumber = TextEditingController(text: '15991574587');
  var _checkboxValue = false;
  var _isLoading = false;

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
              Image.asset('assets/images/schooly-logo.png'),
              SizedBox(
                height: 50.00,
              ),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: idNumber,

                    style: TextStyle(
                      color: Colors.white,
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'שכחת להכניס תעודת זהות';
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
                      labelText: 'תעודת זהות',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                      errorStyle:
                          TextStyle(color: Colors.red[500], fontSize: 18),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _checkboxValue = !_checkboxValue;
                      });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,
                        children: <Widget>[
                          Theme(
                            data:
                                ThemeData(unselectedWidgetColor: Colors.white),
                            child: Checkbox(
                                value: _checkboxValue,
                                onChanged: (bool value) {
                                  setState(() {
                                    _checkboxValue = value;
                                  });
                                }),
                          ),
                          Text(
                            'קראתי ואני מאשר את תנאי השימוש',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10.00,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: _checkboxValue
                          ? () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              setState(() {
                                _isLoading = true;
                              });

                              if (_formKey.currentState.validate()) {
                                await loginProviderHolder
                                    .loginUser(idNumber.text);
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          : null,
                      child: Text(
                        'התחבר למערכת',
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
            ],
          ),
        ),
      ),
    ]);
  }
}
