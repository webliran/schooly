import 'package:flutter/foundation.dart';
import 'package:schooly/models/classeList/dayInfo.dart';
import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ClassProvider extends SchoolyApi with ChangeNotifier {
  String msg;
  String uuid;
  String studentId;
  DateTime currentDate;
  DayInfo dayInfo;
  ClassesList classesList;
  bool idle = false;
  bool showPreloader = false;

  ClassProvider() {
    currentDate = DateTime.now();
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

  void setMainInfo() async {
    uuid = await SharedState().read('uuid');
    studentId = await SharedState().read('studentId');
    await getClassesInfo();
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

  getClassesInfo() async {
    await updateData();
    notifyListeners();
  }

  setToDuplicateSubject(currentLesson, value) {
    currentLesson.toDuplicateSubject = value;
    notifyListeners();
  }

  setToDuplicateMissing(currentLesson, value) {
    currentLesson.toDuplicateMissing = value;
    notifyListeners();
  }

  setToDuplicate(currentLesson, value) {
    currentLesson.toDuplicate = value;
    notifyListeners();
  }

  saveCurrentLessonInfo(currentLesson, lastClass) async {
    String id = currentLesson.id;
    if (currentLesson.toDuplicate) {
      if (currentLesson.toDuplicateSubject) {
        currentLesson.subject = lastClass.subject;
      }
      if (currentLesson.toDuplicateMissing) {
        for (var i = 0; lastClass.disciplineEvents.length > i; i++) {
          print(lastClass.disciplineEvents[i].kind);
          if (lastClass.disciplineEvents[i].kind == "1") {
            var disciplineEventRes = await http.get(
                '$url/?query=SetDisciplineEvent&uuid=$uuid&_id=$id&student_login_id=${lastClass.disciplineEvents[i].student_login_id}&id=${lastClass.disciplineEvents[i].kind}&value=${lastClass.disciplineEvents[i].value}');
            if (disciplineEventRes.statusCode == 200) {
              var disciplineEventJsonResponse =
                  convert.jsonDecode(disciplineEventRes.body);
              if (disciplineEventJsonResponse['success']) {
                currentLesson.disciplineEvents
                    .add(lastClass.disciplineEvents[i]);
              }
            }
          }
        }
      }
    }

    var response = await Future.wait([
      http.get(
          '$url/?query=SetNoReports&uuid=$uuid&_id=$id&value=${currentLesson.noReports}'),
      http.get(
          '$url/?query=SetTimeTable&uuid=$uuid&_id=$id&subject=${currentLesson.subject}'),
      http.get(
          '$url/?query=SetVoidReason&uuid=$uuid&_id=$id&voidReason=${currentLesson.voidReason}')
    ]);

    if (response[0].statusCode == 200 &&
        response[1].statusCode == 200 &&
        response[2].statusCode == 200) {
      var jsonResponseFirst = convert.jsonDecode(response[0].body);
      var jsonResponseSecond = convert.jsonDecode(response[1].body);
      var jsonResponseThird = convert.jsonDecode(response[2].body);

      if (jsonResponseFirst['success'] &&
          jsonResponseSecond['success'] &&
          jsonResponseThird['success']) {
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

  Iterable<AbsentPupil> isAbsent(pupile) {
    return dayInfo.absent_pupils.where(
        (element) => element.student_login_id == pupile.student_login_id);
  }

  getClassesList() async {
    setShowPreloader();
    var classListResponse = await http.get('$url/?query=GetClasses&uuid=$uuid');
    if (classListResponse.statusCode == 200) {
      var classListJsonResponse = convert.jsonDecode(classListResponse.body);
      if (classListJsonResponse['success']) {
        classesList = new ClassesList.fromJson(classListJsonResponse);
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

  updateTimeTableHomeWork(files, currentLesson) async {
    setShowPreloader();
    var filesToSend = "";
    var hFilesList = currentLesson.hFiles.where((item) =>
        FileSystemEntity.typeSync(item) == FileSystemEntityType.notFound);

    if (hFilesList.length > 0) {
      filesToSend = hFilesList.join(',');
    }

    if (hFilesList.length > 0 && files != "") {
      filesToSend += ",";
    }

    if (files != "") {
      filesToSend += files;
    }

    var updateTimeTableResponse = await http.post(
        '$url/?query=SetTimeTable&uuid=$uuid&_id=${currentLesson.id}&subject=${currentLesson.subject}&hContent=${currentLesson.hContent}&hFiles=${filesToSend}');

    if (updateTimeTableResponse.statusCode == 200) {
      var updateTimeTableJsonResponse =
          convert.jsonDecode(updateTimeTableResponse.body);
      if (updateTimeTableJsonResponse['success']) {
        classesList = new ClassesList.fromJson(updateTimeTableJsonResponse);
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

  removeFileHomeWork(currentLesson, i) {
    currentLesson.hFiles.removeAt(i);
    notifyListeners();
  }

  updateFilesHomeWork(currentLesson, files) {
    for (var i = 0; i < files.length; i++) {
      currentLesson.hFiles.add(files[i]);
    }

    notifyListeners();
  }

  uploadFIlesAndInfoHomeWork(currentLesson, lesson_id) async {
    setShowPreloader();

    String uploadUrl =
        '$url/?query=UploadContentFiles&uuid=$uuid&id=$lesson_id&folder=h-timetable';

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    for (var i = 0; i < currentLesson.hFiles.length; i++) {
      if (FileSystemEntity.typeSync(currentLesson.hFiles[i]) !=
          FileSystemEntityType.notFound) {
        request.files.add(http.MultipartFile(
            '[${i}]',
            File(currentLesson.hFiles[i]).readAsBytes().asStream(),
            File(currentLesson.hFiles[i]).lengthSync(),
            filename: currentLesson.hFiles[i].split("/").last));
      }
    }

    var responseFileUpload = await request.send();
    final responseFileUploadJsonFull =
        await responseFileUpload.stream.bytesToString();

    if (responseFileUpload.statusCode == 200) {
      var responseFileUploadJson =
          convert.jsonDecode(responseFileUploadJsonFull);

      if (responseFileUploadJson['success']) {
        print(responseFileUploadJson['fileNames']);
        updateTimeTableHomeWork(
            responseFileUploadJson['fileNames'], currentLesson);
        await updateData();
        notifyListeners();
        return true;
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setPupilClass(currentPupil, isRemove, currentLesson) async {
    int id = isRemove
        ? currentPupil.student_login_id
        : currentPupil["identitynumber"];
    if (isRemove) {
      setShowPreloader();
    }
    var addPartaniResponse = await http.get(
        '$url/?query=SetPartani&uuid=$uuid&id=$id&isRemove=$isRemove&lesson_id=${currentLesson.id}');

    if (addPartaniResponse.statusCode == 200) {
      var addPartaniJsonResponse = convert.jsonDecode(addPartaniResponse.body);

      if (addPartaniJsonResponse['success']) {
        if (isRemove) {
          currentLesson.pupils
              .removeWhere((item) => item.student_login_id == id);
          setHidePreloader();
        } else {
          currentLesson.pupils.add(new Pupils(
            student_login_id: id,
            student_f_name: currentPupil["firstName"],
            student_l_name: currentPupil["lastName"],
          ));
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

  getStudentList(student_class_num, student_class) async {
    var StudentListResponse = await http.get(
        '$url/?query=GetContacts&uuid=$uuid&student_class=$student_class&student_class_num=$student_class_num');
    if (StudentListResponse.statusCode == 200) {
      var StudentListJsonResponse =
          convert.jsonDecode(StudentListResponse.body);
      if (StudentListJsonResponse['success']) {
        return StudentListJsonResponse['data'];
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  updateData() async {
    setShowPreloader();

    var date = new DateFormat("dd/MM/yyyy").format(currentDate);
    var response =
        await http.get('$url/?query=GetTimeTable&uuid=$uuid&date=$date');
    print('$url/?query=GetTimeTable&uuid=$uuid&date=$date');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['success']) {
        dayInfo = new DayInfo.fromJson(jsonResponse['data'][0]);
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

  updateStudentValue(id, student_login_id, eventId, value, status) async {
    var currentLesson;

    currentLesson = dayInfo.data.singleWhere((element) => element.id == id);
    if (status == "checkbox" && value) {
      currentLesson.disciplineEvents.add(new DisciplineEvents(
        id: id,
        student_login_id: student_login_id,
        kind: eventId,
        value: value,
      ));
    } else if (status == "text") {
      var currentState = currentLesson.disciplineEvents.firstWhere(
          (element) =>
              element.student_login_id == student_login_id &&
              element.kind == eventId,
          orElse: () => null);
      if (currentState != null) {
        currentState.text = value;
      } else {
        print("me");

        currentLesson.disciplineEvents.add(new DisciplineEvents(
          id: id,
          student_login_id: student_login_id,
          kind: eventId,
          value: value,
        ));
      }
    } else {
      currentLesson.disciplineEvents.removeWhere((element) =>
          element.student_login_id == student_login_id &&
          element.kind == eventId);
    }
    notifyListeners();

    var response = await http.get(
        '$url/?query=SetDisciplineEvent&uuid=$uuid&_id=$id&student_login_id=$student_login_id&id=$eventId&value=$value');
    /*
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['success']) {
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
    */
  }

  studentValue(student_login_id, eventID, currentId) {
    var currentLesson;
    var currentDiscipline;

    currentLesson =
        dayInfo.data.singleWhere((element) => element.id == currentId);
    currentDiscipline = currentLesson.disciplineEvents.singleWhere(
        (element) =>
            element.student_login_id == student_login_id &&
            element.kind == eventID,
        orElse: () => null);

    if (currentDiscipline != null) {
      return currentDiscipline.value;
    } else {
      if (eventID == "comment") {
        return "";
      } else {
        return false;
      }
    }
  }

  void setDate(DateTime current) async {
    currentDate = current;
    await getClassesInfo();
    notifyListeners();
  }

  void substructDay() async {
    currentDate = currentDate.subtract(new Duration(days: 1));
    await getClassesInfo();
    notifyListeners();
  }

  void addDay() async {
    currentDate = currentDate.add(new Duration(days: 1));
    await getClassesInfo();
    notifyListeners();
  }
}
