import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/components/global/AlertPop.dart';
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
                            showAlertDialog(
                                context,
                                "מחיקת הודעה",
                                "האם אתה בטוח?",
                                () => mailProviderHolder
                                    .deleteMessage(info.messageID),
                                true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('אל: '),
                    Expanded(
                      child: Tags(
                          horizontalScroll: true,
                          itemCount: info.recipients.length,
                          itemBuilder: (index) {
                            return ItemTags(
                              textStyle: TextStyle(
                                fontSize: 12,
                              ),
                              activeColor: Colors.green[400],
                              color: Colors.green[400],
                              textActiveColor: Colors.white,
                              textColor: Colors.white,
                              index: index,
                              removeButton: null,
                              title:
                                  ' ${info.recipients[index].firstName} ${info.recipients[index].lastName} ',
                            );
                          }),
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
