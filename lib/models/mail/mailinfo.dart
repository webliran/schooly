import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'mailinfo.g.dart';

@JsonSerializable()
class MessageList {
  int totalCount;
  int total;
  List<Message> data;

  MessageList({this.data, this.total, this.totalCount});

  factory MessageList.fromJson(Map<String, dynamic> data) =>
      _$MessageListFromJson(data);
}

@JsonSerializable()
class Message {
  String firstName;
  int isTeacher;
  bool filesWereAttached;
  @JsonKey(fromJson: _fromJsonId)
  String messageID;
  String subject;
  String picture;
  String content;
  int fromID;
  @JsonKey(fromJson: _fromJson)
  DateTime date;
  @JsonKey(fromJson: _fromJsonStringToList)
  List groups;
  @JsonKey(fromJson: _fromJsonStringToListFirst)
  String tags;
  String attachedFile;
  String lastName;
  String attachedFile3;
  String attachedFile2;
  int wasRead;
  int rownum;
  bool canReplyAll;
  @JsonKey(defaultValue: true)
  bool canReply;

  Message({
    this.firstName,
    this.isTeacher,
    this.filesWereAttached,
    this.messageID,
    this.subject,
    this.picture,
    this.content,
    this.fromID,
    this.date,
    this.attachedFile,
    this.attachedFile2,
    this.attachedFile3,
    this.lastName,
    this.wasRead,
    this.rownum,
    this.canReply,
    this.canReplyAll,
  });

  factory Message.fromJson(Map<String, dynamic> data) =>
      _$MessageFromJson(data);
}

@JsonSerializable()
class MessageListOut {
  int totalCount;
  int total;
  List<MessageOut> data;

  MessageListOut({this.data, this.total, this.totalCount});

  factory MessageListOut.fromJson(Map<String, dynamic> data) =>
      _$MessageListOutFromJson(data);
}

@JsonSerializable()
class MessageOut {
  @JsonKey(fromJson: _fromJsonId)
  String messageID;
  String subject;
  String content;
  bool filesWereAttached;
  @JsonKey(fromJson: _fromJson)
  DateTime date;
  @JsonKey(fromJson: _fromJsonStringToListFirst)
  String tags;
  String attachedFile;
  String attachedFile3;
  String attachedFile2;
  List<Recipiention> recipients;

  MessageOut(
      {this.messageID,
      this.subject,
      this.content,
      this.date,
      this.attachedFile,
      this.attachedFile2,
      this.attachedFile3,
      this.filesWereAttached});

  factory MessageOut.fromJson(Map<String, dynamic> data) =>
      _$MessageOutFromJson(data);
}

@JsonSerializable()
class Recipiention {
  var identitynumber;
  var student_id;
  String firstName;
  String lastName;

  Recipiention(
      {this.firstName, this.identitynumber, this.lastName, this.student_id});

  factory Recipiention.fromJson(Map<String, dynamic> data) =>
      _$RecipientionFromJson(data);
}

@JsonSerializable()
class MailTags {
  List<MailTag> data;

  MailTags({this.data});

  factory MailTags.fromJson(Map<String, dynamic> data) =>
      _$MailTagsFromJson(data);
}

@JsonSerializable()
class MailTag {
  String name;
  String color;
  String backgroundColor;

  int id;
  MailTag({this.name, this.id, this.color, this.backgroundColor});

  factory MailTag.fromJson(Map<String, dynamic> data) =>
      _$MailTagFromJson(data);
}

@JsonSerializable()
class GroupList {
  List<Group> data;

  GroupList({this.data});

  factory GroupList.fromJson(Map<String, dynamic> data) =>
      _$GroupListFromJson(data);
}

@JsonSerializable()
class Group {
  String key;
  String name;
  @JsonKey(defaultValue: false)
  bool selected;
  @JsonKey(defaultValue: false)
  bool shown;

  Group({this.key, this.name, this.selected, this.shown});

  factory Group.fromJson(Map<String, dynamic> data) => _$GroupFromJson(data);
}

@JsonSerializable()
class GroupMembers {
  List<Member> data;

  GroupMembers({this.data});

  factory GroupMembers.fromJson(Map<String, dynamic> data) =>
      _$GroupMembersFromJson(data);
}

@JsonSerializable()
class Member {
  var student_id;
  var identitynumber;
  String firstName;
  String lastName;
  @JsonKey(defaultValue: false)
  bool selected;

  Member({this.firstName, this.identitynumber, this.lastName, this.student_id});

  factory Member.fromJson(Map<String, dynamic> data) => _$MemberFromJson(data);
}

final _dateFormatter = new DateFormat('hh:mm dd/MM/yy');
DateTime _fromJson(String date) {
  return _dateFormatter.parse(date);
}

String _fromJsonId(id) {
  return id.toString();
}

List _fromJsonStringToList(string) {
  if (string == "") return [];

  return string.split(",");
}

_fromJsonStringToListFirst(string) {
  if (string == "") return "";
  List tags = string.split(",");
  return tags[0];
}
