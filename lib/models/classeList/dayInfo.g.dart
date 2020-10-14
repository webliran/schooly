// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dayInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassesList _$ClassesListFromJson(Map<String, dynamic> json) {
  return ClassesList(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : ClassInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ClassesListToJson(ClassesList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ClassInfo _$ClassInfoFromJson(Map<String, dynamic> json) {
  return ClassInfo(
    student_class_text: json['student_class_text'] as String,
    student_class: json['student_class'] as String,
    student_class_num: json['student_class_num'] as int,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$ClassInfoToJson(ClassInfo instance) => <String, dynamic>{
      'student_class_text': instance.student_class_text,
      'student_class': instance.student_class,
      'student_class_num': instance.student_class_num,
      'value': instance.value,
    };

DayInfo _$DayInfoFromJson(Map<String, dynamic> json) {
  return DayInfo(
    student_f_name: json['student_f_name'] as String,
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    eventTypes: (json['eventTypes'] as List)
        ?.map((e) =>
            e == null ? null : EventTypes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    absent_pupils: (json['absent_pupils'] as List)
        ?.map((e) =>
            e == null ? null : AbsentPupil.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DayInfoToJson(DayInfo instance) => <String, dynamic>{
      'student_f_name': instance.student_f_name,
      'data': instance.data,
      'eventTypes': instance.eventTypes,
      'absent_pupils': instance.absent_pupils,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    name: json['name'] as String,
    id: json['_id'] as String,
    classNames: json['classNames'] as String,
    subject: json['subject'] as String,
    pupils: (json['pupils'] as List)
        ?.map((e) =>
            e == null ? null : Pupils.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    disciplineEvents: (json['disciplineEvents'] as List)
        ?.map((e) => e == null
            ? null
            : DisciplineEvents.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    noReports: json['noReports'] as bool,
    voidReason: json['voidReason'] as String,
    isVoid: json['isVoid'] as bool,
    isPartani: json['isPartani'] as bool,
    hContent: json['hContent'] as String,
    hFiles: json['hFiles'] as List,
    sContent: json['sContent'] as String,
    sFiles: json['sFiles'] as List,
    toDuplicate: json['toDuplicate'] as bool ?? false,
    toDuplicateSubject: json['toDuplicateSubject'] as bool ?? true,
    toDuplicateMissing: json['toDuplicateMissing'] as bool ?? true,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'classNames': instance.classNames,
      'subject': instance.subject,
      'noReports': instance.noReports,
      'isVoid': instance.isVoid,
      'voidReason': instance.voidReason,
      'pupils': instance.pupils,
      'disciplineEvents': instance.disciplineEvents,
      'isPartani': instance.isPartani,
      'hFiles': instance.hFiles,
      'sFiles': instance.sFiles,
      'sContent': instance.sContent,
      'hContent': instance.hContent,
      'toDuplicate': instance.toDuplicate,
      'toDuplicateSubject': instance.toDuplicateSubject,
      'toDuplicateMissing': instance.toDuplicateMissing,
    };

EventTypes _$EventTypesFromJson(Map<String, dynamic> json) {
  return EventTypes(
    json['name'] as String,
    json['id'] as String,
  );
}

Map<String, dynamic> _$EventTypesToJson(EventTypes instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

Pupils _$PupilsFromJson(Map<String, dynamic> json) {
  return Pupils(
    student_login_id: json['student_login_id'] as int,
    student_f_name: json['student_f_name'] as String,
    student_l_name: json['student_l_name'] as String,
  );
}

Map<String, dynamic> _$PupilsToJson(Pupils instance) => <String, dynamic>{
      'student_login_id': instance.student_login_id,
      'student_f_name': instance.student_f_name,
      'student_l_name': instance.student_l_name,
    };

AbsentPupil _$AbsentPupilFromJson(Map<String, dynamic> json) {
  return AbsentPupil(
    student_login_id: json['student_login_id'] as int,
    reason: json['reason'] as String,
  );
}

Map<String, dynamic> _$AbsentPupilToJson(AbsentPupil instance) =>
    <String, dynamic>{
      'student_login_id': instance.student_login_id,
      'reason': instance.reason,
    };

DisciplineEvents _$DisciplineEventsFromJson(Map<String, dynamic> json) {
  return DisciplineEvents(
    id: json['_id'] as String,
    student_login_id: json['student_login_id'] as int,
    kind: json['kind'] as String,
    value: json['value'],
  );
}

Map<String, dynamic> _$DisciplineEventsToJson(DisciplineEvents instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'student_login_id': instance.student_login_id,
      'kind': instance.kind,
      'value': instance.value,
    };
