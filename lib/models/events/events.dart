import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

part 'events.g.dart';

@JsonSerializable()
class EventsList {
  int totalCount;
  List<Event> data;

  EventsList({this.data, this.totalCount});

  factory EventsList.fromJson(Map<String, dynamic> data) =>
      _$EventsListFromJson(data);
}

@JsonSerializable()
class Event {
  @JsonKey(fromJson: _fromJsonId)
  String id;
  String name;
  String body;
  @JsonKey(fromJson: _fromJson)
  DateTime startDate;
  @JsonKey(fromJson: _fromJson)
  DateTime endDate;
  bool is_published;
  bool is_primary;
  String classes;
  int category_id;
  String category_name;
  String backgroundColor;
  String lastName;
  String firstName;
  Event(
      {this.backgroundColor,
      this.body,
      this.category_id,
      this.category_name,
      this.classes,
      this.endDate,
      this.id,
      this.is_primary,
      this.is_published,
      this.name,
      this.startDate,
      this.lastName,
      this.firstName});

  factory Event.fromJson(Map<String, dynamic> data) => _$EventFromJson(data);
}

@JsonSerializable()
class ClassesList {
  List<Classes> data;

  ClassesList({this.data});

  factory ClassesList.fromJson(Map<String, dynamic> data) =>
      _$ClassesListFromJson(data);
}

@JsonSerializable()
class Classes {
  String student_class;
  int student_class_num;
  @JsonKey(fromJson: _fromJsonId)
  String value;
  String student_class_text;
  @JsonKey(defaultValue: false)
  bool selected;

  Classes(
      {this.student_class,
      this.student_class_num,
      this.student_class_text,
      this.value});

  factory Classes.fromJson(Map<String, dynamic> data) =>
      _$ClassesFromJson(data);
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.text, this.firstName, this.lastName);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String text;
  String firstName;
  String lastName;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  String getText(int index) {
    return appointments[index].text;
  }

  String getFirstName(int index) {
    return appointments[index].firstName;
  }

  String getLastName(int index) {
    return appointments[index].lastName;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

String _fromJsonId(id) {
  return id.toString();
}

final _dateFormatter = new DateFormat('dd/MM/yy hh:mm');
DateTime _fromJson(String date) {
  print(date);
  return _dateFormatter.parse(date);
}
