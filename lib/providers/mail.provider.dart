import 'dart:convert';

import 'package:collection/collection.dart';
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
  int limitIn = 10;
  int limitOut = 10;
  Map recep = {};
  List recepList;
  List filePathes = [];
  String selectedTag;

  getRecepList() {
    return recep.entries.map((entry) => [entry.key, entry.value]).toList();
  }

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
    String jsonSelectedUser = await SharedState().read("selectedUser");
    var selectedUser = jsonDecode(jsonSelectedUser);
    currentFirstName = selectedUser["firstName"];
    currentLastName = selectedUser["lastName"];
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
    if (GroupMembersList[id] == null) {
      await getGroupMembers(id);
    }

    notifyListeners();
  }

  clearRecap() {
    recep = {};
    for (var i = 0; i < groupsList.data.length; i++) {
      groupsList.data[i].selected = false;
    }
    if (GroupMembersList != null) {
      GroupMembersList.forEach((key, value) {
        if (value != null) {
          for (var i = 0; i < value.data.length; i++) {
            value.data[i].selected = false;
          }
        }
      });
    }
    notifyListeners();
  }

  clearFiles() {
    filePathes = [];
    notifyListeners();
  }

  setRecap(identitynumber, firstName, lastName) {
    clearRecap();
    recep[identitynumber] = [firstName + " " + lastName, null];

    notifyListeners();
  }

  setMemberSelected(groupId, identity) {
    bool status;
    var currentMember = GroupMembersList[groupId]
        .data
        .where((element) => element.identitynumber == identity)
        .toList();
    status = !currentMember[0].selected;
    currentMember[0].selected = status;
    if (status) {
      recep[currentMember[0].identitynumber] = [
        currentMember[0].firstName + " " + currentMember[0].lastName,
        groupId
      ];
    } else {
      recep.remove(currentMember[0].identitynumber);
    }
    notifyListeners();
  }

  setGroupSelected(id) async {
    if (GroupMembersList[id] == null) {
      setShowPreloader();
      notifyListeners();
      await getGroupMembers(id);
      setHidePreloader();
      notifyListeners();
    }

    bool status;
    var currentGroup =
        groupsList.data.where((element) => element.key == id).toList();

    if (currentGroup.length > 0) {
      status = !currentGroup[0].selected;
      currentGroup[0].selected = status;
      GroupMembersList[id].data.forEach((elem) {
        if (status) {
          recep[elem.identitynumber] = [
            elem.firstName + " " + elem.lastName,
            id
          ];
        } else {
          recep.remove(elem.identitynumber);
        }
        elem.selected = status;
      });
      notifyListeners();
    }
  }

  getGroupAndUpdateRecep(id) async {
    setShowPreloader();
    GroupMembers currentGroup;
    var memberListRes =
        await http.get('$url/?query=GetGroupMembers&uuid=$uuid&key=$id');
    if (memberListRes.statusCode == 200) {
      var memberListResponse = convert.jsonDecode(memberListRes.body);
      if (memberListResponse['success']) {
        setHidePreloader();
        currentGroup = new GroupMembers.fromJson(memberListResponse);
        currentGroup.data.forEach((elem) {
          recep[elem.identitynumber] = [
            elem.firstName + " " + elem.lastName,
            null
          ];
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

  getGroupMembers(id) async {
    var memberListRes =
        await http.get('$url/?query=GetGroupMembers&uuid=$uuid&key=$id');
    if (memberListRes.statusCode == 200) {
      var memberListResponse = convert.jsonDecode(memberListRes.body);
      if (memberListResponse['success']) {
        GroupMembersList[id] = new GroupMembers.fromJson(memberListResponse);
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
          GroupMembersList[element.key] = null;
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
    int currentLimit = 10;
    if (type == "append_new") {
      start = 0;
      limitOut = limitOut != 0 ? limitOut : 10;
      currentLimit = limitOut;
    } else if (type == "append_old") {
      start += 11;
      limitOut += 10;
    }
    print('$url/?query=GetOutBox&uuid=$uuid&start=$start&limit=$currentLimit');

    var outboxResponse = await http.get(
        '$url/?query=GetOutBox&uuid=$uuid&start=$start&limit=$currentLimit');
    if (outboxResponse.statusCode == 200) {
      var outboxJsonResponse = convert.jsonDecode(outboxResponse.body);
      if (outboxJsonResponse['success']) {
        var messageListOutFromApi =
            new MessageListOut.fromJson(outboxJsonResponse);
        if (type == "append_new") {
          messageListOut = messageListOutFromApi;
          if (limitOut > messageListOut.totalCount) {
            limitOut = messageListOut.totalCount;
          }
        } else if (type == "append_old") {
          if (messageListOutFromApi.data.length > 0 &&
              limitOut - 10 < messageListOutFromApi.totalCount)
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
  }

  getInbox(type) async {
    int currentLimit = 10;
    if (type == "append_new") {
      start = 0;
      limitIn = limitIn != 0 ? limitIn : 10;
      currentLimit = limitIn;
    } else if (type == "append_old") {
      start += 11;
      limitIn += 10;
    }
    print('$url/?query=GetInBox&uuid=$uuid&start=$start&limit=$currentLimit');
    var inboxResponse = await http.get(
        '$url/?query=GetInBox&uuid=$uuid&start=$start&limit=$currentLimit');
    if (inboxResponse.statusCode == 200) {
      var inboxJsonResponse = convert.jsonDecode(inboxResponse.body);
      if (inboxJsonResponse['success']) {
        var messageListFromApi = new MessageList.fromJson(inboxJsonResponse);
        if (type == "append_new") {
          messageList = messageListFromApi;
          if (limitIn > messageList.totalCount) {
            limitIn = messageList.totalCount;
          }
        } else if (type == "append_old") {
          if (messageListFromApi.data.length > 0 &&
              limitIn - 10 < messageListFromApi.totalCount)
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

  deleteMessage(messageID) async {
    setShowPreloader();
    print('$url/?query=DeleteMessage&uuid=$uuid&messageID=$messageID');
    var messegeReadResponse = await http
        .get('$url/?query=DeleteMessage&uuid=$uuid&messageID=$messageID');

    if (messegeReadResponse.statusCode == 200) {
      var messegeReadJsonResponse =
          convert.jsonDecode(messegeReadResponse.body);
      if (messegeReadJsonResponse['success']) {
        messageList.data
            .removeWhere((element) => element.messageID == messageID);
        messageListOut.data
            .removeWhere((element) => element.messageID == messageID);
        await getOutBox('append_new');
        setHidePreloader();
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setMessageAsDeleted(messageID) async {
    setShowPreloader();
    print('$url/?query=MarkMessageAsDeleted&uuid=$uuid&messageID=$messageID');
    var messegeReadResponse = await http.get(
        '$url/?query=MarkMessageAsDeleted&uuid=$uuid&messageID=$messageID');

    if (messegeReadResponse.statusCode == 200) {
      var messegeReadJsonResponse =
          convert.jsonDecode(messegeReadResponse.body);
      if (messegeReadJsonResponse['success']) {
        messageList.data
            .removeWhere((element) => element.messageID == messageID);
        await getInbox('append_new');
        setHidePreloader();

        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  mapToRecepString(mapTo) {
    String recepString = "";
    mapTo.forEach((key, elem) {
      print(key.toString());
      recepString += key.toString() + ",";
      print(recepString);
    });

    return recepString.substring(0, recepString.length - 1);
  }

  addToFilePath(path) {
    filePathes.add(path);
    notifyListeners();
  }

  removeFromFilePath(id) {
    filePathes.removeAt(id);
    notifyListeners();
  }

  setSelectedTag(value) {
    selectedTag = value.toString();
    notifyListeners();
  }

  sendMessege(subject, content, reply, replyToAll, messegeId) async {
    setShowPreloader();
    String attachedFileNames = "";
    String uploadUrl;
    for (var i = 0; i < filePathes.length; i++) {
      String isComma = i < filePathes.length ? "," : "";
      attachedFileNames += filePathes[i].split("/").last + isComma;
    }

    if (reply || replyToAll) {
      bool replyType = replyToAll ? true : false;
      uploadUrl =
          '$url/?query=PostReply&uuid=$uuid&subject=$subject&content=$content&attachedFileNames=$attachedFileNames&messageID=$messegeId&replyAll=$replyType';
    } else {
      uploadUrl =
          '$url/?query=PostMessage&uuid=$uuid&subject=$subject&content=$content&attachedFileNames=$attachedFileNames&recipients=${mapToRecepString(recep)}&tags=${selectedTag.toString()}';
    }

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    for (var i = 0; i < filePathes.length; i++) {
      request.files
          .add(await http.MultipartFile.fromPath('[${i}]', filePathes[i]));
    }

    print(request.files.length);
    var responseFileUpload = await request.send();
    final responseFileUploadJsonFull =
        await responseFileUpload.stream.bytesToString();
    if (responseFileUpload.statusCode == 200) {
      var responseFileUploadJson =
          convert.jsonDecode(responseFileUploadJsonFull);
      setHidePreloader();
      if (responseFileUploadJson['success']) {
        print(responseFileUploadJson);
        notifyListeners();
        return true;
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
        return false;
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
      return false;
    }
  }
}
