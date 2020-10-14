// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageList _$MessageListFromJson(Map<String, dynamic> json) {
  return MessageList(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    total: json['total'] as int,
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$MessageListToJson(MessageList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'total': instance.total,
      'data': instance.data,
    };

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    firstName: json['firstName'] as String,
    isTeacher: json['isTeacher'] as int,
    filesWereAttached: json['filesWereAttached'] as bool,
    messageID: _fromJsonId(json['messageID']),
    subject: json['subject'] as String,
    picture: json['picture'] as String,
    content: json['content'] as String,
    fromID: json['fromID'] as int,
    date: _fromJson(json['date'] as String),
    attachedFile: json['attachedFile'] as String,
    attachedFile2: json['attachedFile2'] as String,
    attachedFile3: json['attachedFile3'] as String,
    lastName: json['lastName'] as String,
    wasRead: json['wasRead'] as int,
    rownum: json['rownum'] as int,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'isTeacher': instance.isTeacher,
      'filesWereAttached': instance.filesWereAttached,
      'messageID': instance.messageID,
      'subject': instance.subject,
      'picture': instance.picture,
      'content': instance.content,
      'fromID': instance.fromID,
      'date': instance.date?.toIso8601String(),
      'attachedFile': instance.attachedFile,
      'lastName': instance.lastName,
      'attachedFile3': instance.attachedFile3,
      'attachedFile2': instance.attachedFile2,
      'wasRead': instance.wasRead,
      'rownum': instance.rownum,
    };

MessageListOut _$MessageListOutFromJson(Map<String, dynamic> json) {
  return MessageListOut(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : MessageOut.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    total: json['total'] as int,
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$MessageListOutToJson(MessageListOut instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'total': instance.total,
      'data': instance.data,
    };

MessageOut _$MessageOutFromJson(Map<String, dynamic> json) {
  return MessageOut(
    messageID: _fromJsonId(json['messageID']),
    subject: json['subject'] as String,
    content: json['content'] as String,
    date: _fromJson(json['date'] as String),
    attachedFile: json['attachedFile'] as String,
    attachedFile2: json['attachedFile2'] as String,
    attachedFile3: json['attachedFile3'] as String,
  )..recipients = (json['recipients'] as List)
      ?.map((e) =>
          e == null ? null : Recipiention.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$MessageOutToJson(MessageOut instance) =>
    <String, dynamic>{
      'messageID': instance.messageID,
      'subject': instance.subject,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
      'attachedFile': instance.attachedFile,
      'attachedFile3': instance.attachedFile3,
      'attachedFile2': instance.attachedFile2,
      'recipients': instance.recipients,
    };

Recipiention _$RecipientionFromJson(Map<String, dynamic> json) {
  return Recipiention(
    firstName: json['firstName'] as String,
    identitynumber: json['identitynumber'],
    lastName: json['lastName'] as String,
    student_id: json['student_id'],
  );
}

Map<String, dynamic> _$RecipientionToJson(Recipiention instance) =>
    <String, dynamic>{
      'identitynumber': instance.identitynumber,
      'student_id': instance.student_id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

MailTags _$MailTagsFromJson(Map<String, dynamic> json) {
  return MailTags(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : MailTag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MailTagsToJson(MailTags instance) => <String, dynamic>{
      'data': instance.data,
    };

MailTag _$MailTagFromJson(Map<String, dynamic> json) {
  return MailTag(
    name: json['name'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$MailTagToJson(MailTag instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

GroupList _$GroupListFromJson(Map<String, dynamic> json) {
  return GroupList(
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupListToJson(GroupList instance) => <String, dynamic>{
      'data': instance.data,
    };

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    key: json['key'] as String,
    name: json['name'] as String,
    selected: json['selected'] as bool ?? false,
    shown: json['shown'] as bool ?? false,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'selected': instance.selected,
      'shown': instance.shown,
    };

GroupMembers _$GroupMembersFromJson(Map<String, dynamic> json) {
  return GroupMembers(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupMembersToJson(GroupMembers instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    firstName: json['firstName'] as String,
    identitynumber: json['identitynumber'],
    lastName: json['lastName'] as String,
    student_id: json['student_id'],
  )..selected = json['selected'] as bool ?? true;
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'student_id': instance.student_id,
      'identitynumber': instance.identitynumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'selected': instance.selected,
    };
