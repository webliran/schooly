import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:schooly/components/messages/IncomeBox.dart';
import 'package:schooly/components/messages/NewMessege.dart';
import 'package:schooly/components/messages/OutBox.dart';
import 'package:schooly/providers/mail.provider.dart';

class Messages extends StatefulWidget {
  final String currentId;

  Messages({this.currentId});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();
    return Stack(children: <Widget>[
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('תיבת דואר')),
            actions: <Widget>[
              PopUpMenu(),
            ],
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: IncomeBox()),
              Container(child: OutBox()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NewMessege(
                      reply: false,
                      replyToAll: false,
                      messegeId: null,
                    );
                  },
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    ]);
  }
}

Widget menu() {
  return Container(
    color: Colors.blueAccent,
    child: TabBar(
      tabs: [
        Tab(text: "דואר נכנס", icon: Icon(Icons.mail_outline)),
        Tab(text: "דואר יוצא", icon: Icon(Icons.outgoing_mail)),
      ],
    ),
  );
}
