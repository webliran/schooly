import 'package:flutter/material.dart';
import 'package:schooly/components/events/EventBox.dart';
import 'package:schooly/components/events/NewEvent.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:schooly/models/events/events.dart';
import 'package:schooly/providers/events.provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Color hexToColor(String code) {
    if (code != null)
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void displayBottomSheet(BuildContext context, appointmentDetails) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          var galleryProviderHolder = ctx.watch<EventsProvider>();

          return ListView.builder(
              itemCount: appointmentDetails.appointments.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return EventBox(appointmentDetails.appointments[index]);
              });
        });
  }

  void calendarTapped(CalendarTapDetails details) {
    displayBottomSheet(context, details);
  }

  @override
  Widget build(BuildContext context) {
    var eventsProviderHolder = context.watch<EventsProvider>();
    List<Meeting> _getDataSource() {
      var meetings = <Meeting>[];
      eventsProviderHolder.events.data.forEach((element) {
        print(element.startDate);
        meetings.add(Meeting(
            element.name,
            element.startDate,
            element.endDate,
            hexToColor(element.backgroundColor),
            false,
            element.body,
            element.firstName,
            element.lastName));
      });

      /*
      final DateTime today = DateTime.now();
      final DateTime startTime =
          DateTime(today.year, today.month, today.day, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(days: 2));
      */
      print(meetings);
      return meetings;
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('אירועים')),
          actions: <Widget>[
            PopUpMenu(),
          ],
        ),
        body: Stack(
          children: [
            eventsProviderHolder.events != null &&
                    eventsProviderHolder.events.data.length > 0
                ? SfCalendar(
                    showDatePickerButton: true,
                    view: CalendarView.month,
                    firstDayOfWeek: 0,
                    onTap: calendarTapped,
                    dataSource: MeetingDataSource(_getDataSource()),
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            eventsProviderHolder.showPreloader
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NewEvent();
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
