import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/global/AlertPop.dart';
import 'package:schooly/components/messages/MessegePopOut.dart';
import 'package:schooly/components/messages/messegePop.dart';
import 'package:schooly/providers/mail.provider.dart';
import 'package:intl/intl.dart';

class MailItemListOut extends StatelessWidget {
  final info;
  MailItemListOut(this.info);
  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();
    var now = new DateTime.now();
    final _dateFormatter = new DateFormat('hh:mm dd/MM/yy');
    var currentTag = mailProviderHolder.tagsList.data.where((element) {
      return info.tags == element.id.toString();
    }).toList();
    String currentDate;
    if (DateFormat('dd/MM/yy').format(info.date) ==
        DateFormat('dd/MM/yy').format(now)) {
      currentDate = DateFormat('hh:mm').format(info.date);
    } else if (DateFormat('yy').format(info.date) ==
        DateFormat('yy').format(now)) {
      currentDate = DateFormat('dd/MM').format(info.date);
    } else {
      currentDate = DateFormat('dd/MM/yy').format(info.date);
    }
    Color hexToColor(String code) {
      if (code != null)
        return new Color(
            int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return messegePopOut(info: info);
              },
            ),
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${mailProviderHolder.currentFirstName} ${mailProviderHolder.currentLastName}'),
            Text(currentDate, style: TextStyle(fontSize: 14)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(info.subject),
            Row(
              children: [
                currentTag.length > 0
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200]),
                          color: hexToColor(currentTag[0].backgroundColor),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          '${currentTag[0].name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: hexToColor(currentTag[0].color),
                          ),
                        ),
                      )
                    : Container(),
                info.filesWereAttached
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]),
                            color: Colors.blueAccent[200]),
                        child: Icon(Icons.attach_file,
                            size: 16, color: Colors.white),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            showAlertDialog(context, "מחיקת הודעה", "האם אתה בטוח?",
                () => mailProviderHolder.deleteMessage(info.messageID), false);
          },
        ),
      ),
    );
  }
}
