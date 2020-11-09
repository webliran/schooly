import 'package:flutter/material.dart';
import 'package:schooly/components/global/AlertPop.dart';
import 'package:schooly/providers/events.provider.dart';
import 'package:provider/provider.dart';

class EventBox extends StatelessWidget {
  final event;

  EventBox(this.event);
  @override
  Widget build(BuildContext context) {
    var eventsProviderHolder = context.watch<EventsProvider>();

    return Card(
      child: ListTile(
        onTap: () {},
        leading: Icon(Icons.event),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${event.firstName} ${event.lastName}',
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event.eventName,
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            showAlertDialog(context, "מחיקת הודעה", "האם אתה בטוח?",
                () => eventsProviderHolder.setEventAsDeleted(event.id), false);
            //mailProviderHolder.setMessageAsDeleted(info.messageID);
          },
        ),
      ),
    );
  }
}
