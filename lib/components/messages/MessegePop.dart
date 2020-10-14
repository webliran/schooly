import 'package:flutter/material.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schooly/components/messages/FileAtt.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/messages/NewMessege.dart';
import 'package:schooly/providers/mail.provider.dart';

class messegePop extends StatelessWidget {
  var info;

  messegePop({this.info});

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
                          icon: Icon(Icons.reply),
                          color: Colors.blueAccent,
                          onPressed: () {
                            print(info.messageID);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewMessege(
                                    reply: true,
                                    replyToAll: false,
                                    messegeId: info.messageID,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.reply_all),
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewMessege(
                                    reply: false,
                                    replyToAll: true,
                                    messegeId: info.messageID,
                                  );
                                },
                              ),
                            );
                          },
                        ),
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
                        CircleAvatar(
                          child: info.picture == "nopic.gif"
                              ? Text('${info.firstName[0]}.${info.lastName[0]}',
                                  style: TextStyle(fontSize: 16))
                              : Image.network(info.picture),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${info.firstName} ${info.lastName}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
