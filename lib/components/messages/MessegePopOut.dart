import 'package:flutter/material.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schooly/components/messages/FileAtt.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/mail.provider.dart';

class messegePopOut extends StatelessWidget {
  var info;

  messegePopOut({this.info});

  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          '${info.subject}',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: <Widget>[
          PopUpMenu(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${DateFormat('dd/MM/yy hh:mm').format(info.date)}'),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.pop(context);
                            mailProviderHolder
                                .setMessageAsDeleted(info.messageID);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        info.recipients.length > 0
                            ? Text(
                                'אל: ${info.recipients[0].firstName} ${info.recipients[0].lastName}',
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Container(
                  child: Html(data: info.content),
                ),
                Divider(),
                info.attachedFile != ""
                    ? FileAtt(file: info.attachedFile)
                    : Container(),
                info.attachedFile2 != ""
                    ? FileAtt(file: info.attachedFile2)
                    : Container(),
                info.attachedFile3 != ""
                    ? FileAtt(file: info.attachedFile3)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
