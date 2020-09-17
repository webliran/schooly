import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:schooly/components/homework/ClassList.dart';
import 'package:schooly/providers/classes.provider.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:intl/intl.dart';

class HomeworkManagement extends StatefulWidget {
  @override
  _HomeworkManagementState createState() => _HomeworkManagementState();
}

class _HomeworkManagementState extends State<HomeworkManagement> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    var classProviderHolder = context.read<ClassProvider>();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      classProviderHolder.setDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();
    var loginProviderHolder = context.watch<LoginProvider>();

    formatDate(date) {
      print(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formatted = formatter.format(date);
      return formatted;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ניהול שיעורים')),
        actions: <Widget>[
          PopUpMenu(),
        ],
      ),
      body:
          /*FutureBuilder(
          future: loginProviderHolder.selectUser(null),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(snapshot);
              return Text('sdfdsfds');
            } else {
              return CircularProgressIndicator();
            }
          })*/
          Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          if (!classProviderHolder.showPreloader) {
                            classProviderHolder.substructDay();
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_left,
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        await _selectDate(context);
                      },
                      child: Text(
                        "${formatDate(classProviderHolder.currentDate)}"
                            .split(' ')[0],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        if (!classProviderHolder.showPreloader) {
                          classProviderHolder.addDay();
                        }
                      },
                      child: Icon(
                        Icons.arrow_right,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                ClassList(),
              ],
            ),
          ),
          classProviderHolder.showPreloader
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[CircularProgressIndicator()],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
