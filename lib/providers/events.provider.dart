import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:schooly/models/events/events.dart';

import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';

class EventsProvider extends SchoolyApi with ChangeNotifier {
  String msg;
  String uuid;
  String studentId;
  bool showPreloader = false;
  String currentFirstName;
  String currentLastName;
  List filePathes = [];
  ClassesList classesList;
  EventsList events;

  EventsProvider() {
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
    getEvents();
  }

  addFilesToPaths(file) {
    filePathes.add(file);

    notifyListeners();
  }

  removeFilesToPaths(index) {
    filePathes.removeAt(index);
    notifyListeners();
  }

  getGroups() async {
    var classesListRes = await http.get('$url/?query=GetClasses&uuid=$uuid');
    if (classesListRes.statusCode == 200) {
      var classesListResponse = convert.jsonDecode(classesListRes.body);
      if (classesListResponse['success']) {
        classesList = new ClassesList.fromJson(classesListResponse);
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setEventAsDeleted(id) {}

  getEvents() async {
    var eventsListRes = await http.get('$url/?query=GetUserEvents&uuid=$uuid');
    if (eventsListRes.statusCode == 200) {
      var eventsListResponse = convert.jsonDecode(eventsListRes.body);
      if (eventsListResponse['success']) {
        print(eventsListResponse);
        events = new EventsList.fromJson(eventsListResponse);

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
}
