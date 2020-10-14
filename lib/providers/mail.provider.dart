import 'package:flutter/foundation.dart';
import 'package:schooly/models/mail/mailinfo.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class MailProvider extends SchoolyApi with ChangeNotifier {
  String msg;
  String uuid;
  String studentId;
  MessageList messageList;
  MessageListOut messageListOut;
  MailTags tagsList;
  GroupList groupsList;
  Map GroupMembersList = {};
  bool showPreloader = false;
  String currentFirstName;
  String currentLastName;
  int start = 0;
  int limit = 10;

  MailProvider() {
    setMainInfo();
  }
  void setShowPreloader() {
    showPreloader = true;
    notifyListeners();
  }

  void setHidePreloader() {
    showPreloader = false;
    notifyListeners();
  }

  void showWebColoredToast() {
    String msgFinal = Translate().translations[msg] != ""
        ? Translate().translations[msg]
        : msg;
    print(msgFinal);
    Fluttertoast.showToast(
      msg: msgFinal,
      toastLength: Toast.LENGTH_LONG,
      webBgColor: "#e74c3c",
      timeInSecForIosWeb: 5,
    );
  }

  void setMainInfo() async {
    uuid = await SharedState().read('uuid');
    studentId = await SharedState().read('studentId');
    currentFirstName = await SharedState().read("firstName");
    currentLastName = await SharedState().read("lastName");
    await getGroups();
    await getMailTags();
    await getInbox("append_new");
    await getOutBox("append_new");
  }

  setGroupShownHidden(id) async {
    var currentGroup =
        groupsList.data.where((element) => element.key == id).toList();
    currentGroup[0].shown = !currentGroup[0].shown;
    notifyListeners();
  }

  setGroupSelected(id) async {
    var currentGroup =
        groupsList.data.where((element) => element.key == id).toList();
    currentGroup[0].selected = !currentGroup[0].selected;
    notifyListeners();

    var memberListRes =
        await http.get('$url/?query=GetGroupMembers&uuid=$uuid&key=$id');
    if (memberListRes.statusCode == 200) {
      var memberListResponse = convert.jsonDecode(memberListRes.body);
      if (memberListResponse['success']) {
        GroupMembersList[id] = new GroupMembers.fromJson(memberListResponse);
        print(GroupMembersList[id]);
        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getGroups() async {
    var groupsListRes = await http.get('$url/?query=GetGroups&uuid=$uuid');
    if (groupsListRes.statusCode == 200) {
      var groupsListResponse = convert.jsonDecode(groupsListRes.body);
      if (groupsListResponse['success']) {
        groupsList = new GroupList.fromJson(groupsListResponse);
        groupsList.data.forEach((element) {
          GroupMembersList[element.key] = {};
        });

        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getMailTags() async {
    var mailTags = await http.get('$url/?query=GetMailTags&uuid=$uuid');
    if (mailTags.statusCode == 200) {
      var mailTagsResponse = convert.jsonDecode(mailTags.body);
      if (mailTagsResponse['success']) {
        tagsList = new MailTags.fromJson(mailTagsResponse);
        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getOutBox(type) async {
    setShowPreloader();

    int currentLimit = 10;
    if (type == "append_new") {
      start = 0;
      currentLimit = limit;
    } else if (type == "append_old") {
      start += 11;
      limit += 10;
    }

    var outboxResponse = await http.get(
        '$url/?query=GetOutBox&uuid=$uuid&start=$start&limit=$currentLimit');
    if (outboxResponse.statusCode == 200) {
      var outboxJsonResponse = convert.jsonDecode(outboxResponse.body);
      if (outboxJsonResponse['success']) {
        var messageListOutFromApi =
            new MessageListOut.fromJson(outboxJsonResponse);
        if (type == "append_new") {
          messageListOut = messageListOutFromApi;
          if (limit > messageListOut.totalCount) {
            limit = messageListOut.totalCount;
          }
        } else if (type == "append_old") {
          if (messageListOutFromApi.data.length > 0 &&
              limit - 10 < messageListOutFromApi.totalCount)
            messageListOut.data += messageListOutFromApi.data;
        }

        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    setHidePreloader();
  }

  getInbox(type) async {
    setShowPreloader();
    int currentLimit = 10;
    if (type == "append_new") {
      start = 0;
      currentLimit = limit;
    } else if (type == "append_old") {
      start += 11;
      limit += 10;
    }
    var inboxResponse = await http.get(
        '$url/?query=GetInBox&uuid=$uuid&start=$start&limit=$currentLimit');
    if (inboxResponse.statusCode == 200) {
      var inboxJsonResponse = convert.jsonDecode(inboxResponse.body);
      if (inboxJsonResponse['success']) {
        var messageListFromApi = new MessageList.fromJson(inboxJsonResponse);
        if (type == "append_new") {
          messageList = messageListFromApi;
          if (limit > messageList.totalCount) {
            limit = messageList.totalCount;
          }
        } else if (type == "append_old") {
          if (messageListFromApi.data.length > 0 &&
              limit - 10 < messageListFromApi.totalCount)
            messageList.data += messageListFromApi.data;
        }

        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    setHidePreloader();
  }

  setMessegeRead(messageID) async {
    var messegeReadResponse = await http
        .get('$url/?query=MarkMessageAsRead&uuid=$uuid&messageID=$messageID');
    if (messegeReadResponse.statusCode == 200) {
      var messegeReadJsonResponse =
          convert.jsonDecode(messegeReadResponse.body);
      if (messegeReadJsonResponse['success']) {
        var currentMessege = messageList.data
            .where((element) => element.messageID == messageID)
            .toList();
        currentMessege[0].wasRead = 1;
        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setMessageAsDeleted(messageID) async {
    var messegeReadResponse = await http.get(
        '$url/?query=MarkMessageAsDeleted&uuid=$uuid&messageID=$messageID');
    if (messegeReadResponse.statusCode == 200) {
      var messegeReadJsonResponse =
          convert.jsonDecode(messegeReadResponse.body);
      if (messegeReadJsonResponse['success']) {
        messageList.data
            .removeWhere((element) => element.messageID == messageID);
        messageListOut.data
            .removeWhere((element) => element.messageID == messageID);
        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  sendMessege(subject, content, files, reply, replyToAll, messegeId) async {
    String attachedFileNames = "";
    String uploadUrl;
    for (var i = 0; i < files.length; i++) {
      attachedFileNames += files[i].split("/").last;
    }

    if (reply || replyToAll) {
      bool replyType = replyToAll ? true : false;
      uploadUrl =
          '$url/?query=PostReply&uuid=$uuid&subject=$subject&content=$content&attachedFileNames=$attachedFileNames&messageID=$messegeId&replyAll=$replyType';
      print(uploadUrl);
    } else {
      uploadUrl =
          '$url/?query=PostMessage&uuid=$uuid&subject=$subject&content=$content&attachedFileNames=$attachedFileNames&recipients=039407168';
    }
    print(uploadUrl);
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    for (var i = 0; i < files.length; i++) {
      if (FileSystemEntity.typeSync(files[i]) !=
          FileSystemEntityType.notFound) {
        request.files.add(http.MultipartFile(
            '[${i}]',
            File(files[i]).readAsBytes().asStream(),
            File(files[i]).lengthSync(),
            filename: files[i].split("/").last));
      }
    }

    var responseFileUpload = await request.send();
    final responseFileUploadJsonFull =
        await responseFileUpload.stream.bytesToString();

    print(responseFileUploadJsonFull);
  }
}
