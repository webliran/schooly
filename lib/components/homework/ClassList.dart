import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schooly/components/homework/TabedPupils.dart';
import 'package:schooly/providers/classes.provider.dart';
import 'package:provider/provider.dart';

class DuplicateInfo extends StatelessWidget {
  final lastClass;
  final currentLesson;
  final classProviderHolder;
  DuplicateInfo({this.currentLesson, this.lastClass, this.classProviderHolder});

  deepEq(listA, listB) {
    bool equal = true;
    for (var i = 0; i < listA.length; i++) {
      List isExsist = listB
          .where((item) => item.student_login_id == listA[i].student_login_id)
          .toList();

      if (isExsist.length == 0) {
        equal = false;
      }
    }
    return equal;
  }

  @override
  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();
    if (lastClass != null &&
        currentLesson.classNames == lastClass.classNames &&
        currentLesson.name == lastClass.name &&
        currentLesson.classNames == lastClass.classNames &&
        deepEq(currentLesson.pupils, lastClass.pupils) &&
        (lastClass.subject != "" || lastClass.disciplineEvents.length != 0)) {
      return Column(
        children: [
          CheckboxListTile(
            value: currentLesson.toDuplicate,
            title: const Text(
              'העתק משיעור קודם',
              style: TextStyle(fontSize: 13),
            ),
            onChanged: (bool value) {
              classProviderHolder.setToDuplicate(currentLesson, value);
            },
            secondary: const Icon(Icons.content_copy),
          ),
          currentLesson.toDuplicate
              ? Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: currentLesson.toDuplicateSubject,
                        title: const Text(
                          'העתק נושא השיעור',
                          style: TextStyle(fontSize: 13),
                        ),
                        onChanged: (bool value) {
                          classProviderHolder.setToDuplicateSubject(
                              currentLesson, value);
                        },
                        secondary: const Icon(Icons.title),
                      ),
                      CheckboxListTile(
                        value: currentLesson.toDuplicateMissing,
                        title: const Text(
                          'העתק חיסורים',
                          style: TextStyle(fontSize: 13),
                        ),
                        onChanged: (bool value) {
                          classProviderHolder.setToDuplicateMissing(
                              currentLesson, value);
                        },
                        secondary: const Icon(Icons.school),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      );
    }
    return Container();
  }
}

class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  _classInfoModal(classProviderHolder, BuildContext context, id) {
    var currentLesson = classProviderHolder.dayInfo.data
        .singleWhere((element) => element.id == id);

    int currentIndex = classProviderHolder.dayInfo.data
        .indexWhere((element) => element.id == id);
    currentLesson.toDuplicate = false;
    var lastClass = currentIndex == 0
        ? null
        : classProviderHolder.dayInfo.data[currentIndex - 1];

    showDialog(
        context: context,
        builder: (_) {
          bool isVoid = currentLesson.voidReason == "" ? false : true;
          bool _isLoadingModal = false;
          final _formKey = GlobalKey<FormState>();

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'אפשרויות ' +
                      currentLesson.name +
                      " " +
                      currentLesson.classNames,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CheckboxListTile(
                        value: currentLesson.noReports,
                        title: const Text(
                          'השיעור עבר ללא אירועים',
                          style: TextStyle(fontSize: 13),
                        ),
                        onChanged: (bool value) {
                          currentLesson.noReports = value;
                          currentLesson.subject = "";
                          currentLesson.voidReason = "";
                          setState(() {
                            isVoid = false;
                          });
                        },
                        secondary: const Icon(Icons.thumb_up),
                      ),
                      currentLesson.noReports
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  currentLesson.subject = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'נושא השיעור'),
                                initialValue: currentLesson.subject,
                              ),
                            )
                          : Container(),
                      CheckboxListTile(
                        value: isVoid,
                        title: const Text(
                          'השיעור בוטל',
                          style: TextStyle(fontSize: 13),
                        ),
                        secondary: const Icon(Icons.cancel),
                        onChanged: (bool value) {
                          currentLesson.noReports = false;
                          currentLesson.subject = "";
                          currentLesson.voidReason = "";
                          setState(() {
                            isVoid = value;
                          });
                        },
                      ),
                      isVoid
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: TextFormField(
                                onChanged: (value) {
                                  currentLesson.voidReason = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'סיבת הביטול'),
                                initialValue: currentLesson.voidReason,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'יש להיזן סיבת ביטול';
                                  }
                                  return null;
                                },
                              ),
                            )
                          : Container(),
                      DuplicateInfo(
                        currentLesson: currentLesson,
                        lastClass: lastClass,
                        classProviderHolder: classProviderHolder,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoadingModal = !_isLoadingModal;
                                });
                                await classProviderHolder.saveCurrentLessonInfo(
                                    currentLesson, lastClass);

                                setState(() {
                                  _isLoadingModal = !_isLoadingModal;
                                });
                                Navigator.pop(context);
                              } else {}
                            },
                            child: Text('שמור',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      _isLoadingModal ? LinearProgressIndicator() : SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();
    return SingleChildScrollView(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: classProviderHolder.dayInfo != null &&
                classProviderHolder.dayInfo.data.length > 0
            ? classProviderHolder.dayInfo.data.map<Widget>((item) {
                Widget icon = item.voidReason != "" ||
                        item.disciplineEvents.length > 0 ||
                        item.noReports
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                      )
                    : Icon(Icons.update);

                return Card(
                  child: ListTile(
                    leading: icon,
                    title: Row(children: [
                      item.classNames != ""
                          ? Text(item.classNames)
                          : SizedBox(),
                      SizedBox(width: 20),
                      Text(item.name)
                    ]),
                    subtitle:
                        item.subject != "" ? Text(item.subject) : SizedBox(),
                    trailing: GestureDetector(
                      child: Icon(Icons.more_vert),
                      onTap: () {
                        _classInfoModal(classProviderHolder, context, item.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TabedPupils(currentID: item.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              }).toList()
            : [
                Center(child: Text("לא נמצאו שיעורים")),
              ],
      ),
    );
  }
}
