// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsList _$EventsListFromJson(Map<String, dynamic> json) {
  return EventsList(
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$EventsListToJson(EventsList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'data': instance.data,
    };

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    backgroundColor: json['backgroundColor'] as String,
    body: json['body'] as String,
    category_id: json['category_id'] as int,
    category_name: json['category_name'] as String,
    classes: json['classes'] as String,
    endDate: _fromJson(json['endDate'] as String),
    id: _fromJsonId(json['id']),
    is_primary: json['is_primary'] as bool,
    is_published: json['is_published'] as bool,
    name: json['name'] as String,
    startDate: _fromJson(json['startDate'] as String),
    lastName: json['lastName'] as String,
    firstName: json['firstName'] as String,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'body': instance.body,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'is_published': instance.is_published,
      'is_primary': instance.is_primary,
      'classes': instance.classes,
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'backgroundColor': instance.backgroundColor,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
    };

ClassesList _$ClassesListFromJson(Map<String, dynamic> json) {
  return ClassesList(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Classes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ClassesListToJson(ClassesList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Classes _$ClassesFromJson(Map<String, dynamic> json) {
  return Classes(
    student_class: json['student_class'] as String,
    student_class_num: json['student_class_num'] as int,
    student_class_text: json['student_class_text'] as String,
    value: _fromJsonId(json['value']),
  )..selected = json['selected'] as bool ?? false;
}

Map<String, dynamic> _$ClassesToJson(Classes instance) => <String, dynamic>{
      'student_class': instance.student_class,
      'student_class_num': instance.student_class_num,
      'value': instance.value,
      'student_class_text': instance.student_class_text,
      'selected': instance.selected,
    };
