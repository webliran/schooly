import 'package:flutter/material.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/components/global/AlertPop.dart';
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${DateFormat('dd/MM/yy hh:mm').format(info.date)}'),
                          Row(
                            children: [
                              info.canReply
                                  ? IconButton(
                                      icon: Icon(Icons.reply),
                                      color: Colors.blueAccent,
                                      onPressed: () async {
                                        mailProviderHolder.clearFiles();
                                        mailProviderHolder.setRecap(info.fromID,
                                            info.firstName, info.lastName);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return NewMessege(
                                                  reply: true,
                                                  replyToAll: false,
                                                  messegeInfo: info);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : Container(),
                              info.canReplyAll
                                  ? IconButton(
                                      icon: Icon(Icons.reply_all),
                                      color: Colors.blueAccent,
                                      onPressed: () async {
                                        mailProviderHolder.clearFiles();
                                        mailProviderHolder.clearRecap();

                                        if (info.groups.length > 0) {
                                          for (var i = 0;
                                              i < info.groups.length;
                                              i++) {
                                            print(info.groups[i]);
                                            await mailProviderHolder
                                                .getGroupAndUpdateRecep(
                                                    info.groups[i]);
                                          }
                                        } else {
                                          mailProviderHolder.setRecap(
                                              info.fromID,
                                              info.firstName,
                                              info.lastName);
                                        }
                                        print(mailProviderHolder.recep.length);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return NewMessege(
                                                  reply: false,
                                                  replyToAll: true,
                                                  messegeInfo: info);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : Container(),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  Navigator.pop(context);
                                  showAlertDialog(
                                      context,
                                      "מחיקת הודעה",
                                      "האם אתה בטוח?",
                                      () => mailProviderHolder
                                          .setMessageAsDeleted(info.messageID),
                                      true);
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
                                    ? Text(
                                        '${info.firstName[0]}.${info.lastName[0]}',
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
            mailProviderHolder.showPreloader
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
        ));
  }
}
