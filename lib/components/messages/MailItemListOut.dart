import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            Text(currentDate),
          ],
        ),
        subtitle: Text(info.subject),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
