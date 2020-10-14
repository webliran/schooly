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
            Text(currentDate),
          ],
        ),
        subtitle: Text(info.subject,
            style: TextStyle(
                fontWeight:
                    info.wasRead == 1 ? FontWeight.normal : FontWeight.bold)),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
