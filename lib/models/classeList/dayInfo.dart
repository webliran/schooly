import 'package:json_annotation/json_annotation.dart';

part 'dayInfo.g.dart';

@JsonSerializable()
class ClassesList {
  final List<ClassInfo> data;

  ClassesList({this.data});

  factory ClassesList.fromJson(Map<String, dynamic> data) =>
      _$ClassesListFromJson(data);
}

@JsonSerializable()
class ClassInfo {
  final String student_class_text;
  final String student_class;
  final int student_class_num;
  final int value;

  ClassInfo(
      {this.student_class_text,
      this.student_class,
      this.student_class_num,
      this.value});

  factory ClassInfo.fromJson(Map<String, dynamic> data) =>
      _$ClassInfoFromJson(data);
}

@JsonSerializable()
class DayInfo {
  final String student_f_name;
  final List<Data> data;
  final List<EventTypes> eventTypes;
  final List<AbsentPupil> absent_pupils;

  DayInfo(
      {this.student_f_name, this.data, this.eventTypes, this.absent_pupils});

  factory DayInfo.fromJson(Map<String, dynamic> data) =>
      _$DayInfoFromJson(data);
}

@JsonSerializable()
class Data {
  @JsonKey(name: '_id')
  String id;
  final String name;
  final String classNames;
  String subject;
  bool noReports;
  bool isVoid;
  String voidReason;
  final List<Pupils> pupils;
  List<DisciplineEvents> disciplineEvents;
  bool isPartani;
  List hFiles;
  List sFiles;
  String sContent;
  String hContent;
  @JsonKey(defaultValue: false)
  bool toDuplicate;
  @JsonKey(defaultValue: true)
  bool toDuplicateSubject;
  @JsonKey(defaultValue: true)
  bool toDuplicateMissing;
  Data(
      {this.name,
      this.id,
      this.classNames,
      this.subject,
      this.pupils,
      this.disciplineEvents,
      this.noReports,
      this.voidReason,
      this.isVoid,
      this.isPartani,
      this.hContent,
      this.hFiles,
      this.sContent,
      this.sFiles,
      this.toDuplicate,
      this.toDuplicateSubject,
      this.toDuplicateMissing});

  factory Data.fromJson(Map<String, dynamic> data) => _$DataFromJson(data);
}

@JsonSerializable()
class EventTypes {
  final String name;
  final String id;

  EventTypes(this.name, this.id);

  factory EventTypes.fromJson(Map<String, dynamic> data) =>
      _$EventTypesFromJson(data);
}

@JsonSerializable()
class Pupils {
  final int student_login_id;
  final String student_f_name;
  final String student_l_name;

  Pupils({this.student_login_id, this.student_f_name, this.student_l_name});

  factory Pupils.fromJson(Map<String, dynamic> data) => _$PupilsFromJson(data);
}

@JsonSerializable()
class AbsentPupil {
  final int student_login_id;
  final String reason;

  AbsentPupil({this.student_login_id, this.reason});

  factory AbsentPupil.fromJson(Map<String, dynamic> data) =>
      _$AbsentPupilFromJson(data);
}

@JsonSerializable()
class DisciplineEvents {
  @JsonKey(name: '_id')
  String id;
  final int student_login_id;
  final String kind;
  dynamic value;

  DisciplineEvents({this.id, this.student_login_id, this.kind, this.value});

  void set text(String text) {
    this.value = text;
  }

  factory DisciplineEvents.fromJson(Map<String, dynamic> data) =>
      _$DisciplineEventsFromJson(data);
}
