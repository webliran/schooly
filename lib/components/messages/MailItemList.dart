import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schooly/components/messages/messegePop.dart';
import 'package:schooly/providers/mail.provider.dart';
import 'package:intl/intl.dart';

class MailItemList extends StatelessWidget {
  final info;
  MailItemList(this.info);
  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();
    var currentTag = mailProviderHolder.tagsList.data.where((element) {
      return info.tags == element.id.toString();
    }).toList();
    var now = new DateTime.now();
    final _dateFormatter = new DateFormat('hh:mm dd/MM/yy');
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
          mailProviderHolder.setMessegeRead(info.messageID);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return messegePop(info: info);
              },
            ),
          );
        },
        leading: CircleAvatar(
          child: info.picture == "nopic.gif"
              ? Text('${info.firstName[0]}.${info.lastName[0]}')
              : Image.network(info.picture),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${info.firstName} ${info.lastName}',
                style: TextStyle(
                    fontWeight: info.wasRead == 1
                        ? FontWeight.normal
                        : FontWeight.bold)),
            Column(
              children: [
                Text(currentDate, style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(info.subject,
                style: TextStyle(
                    fontWeight: info.wasRead == 1
                        ? FontWeight.normal
                        : FontWeight.bold)),
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
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            mailProviderHolder.setMessageAsDeleted(info.messageID);
          },
        ),
      ),
    );
  }
}
