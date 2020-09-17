import 'package:flutter/material.dart';
import 'package:schooly/models/dayInfo.dart';
import 'package:schooly/providers/classes.provider.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ChildrenList extends StatefulWidget {
  final String currentId;

  ChildrenList({this.currentId});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  var currentLesson;

  List selectedUsers = [];
  List currentStudents;

  _showDeleteConfirmDialog(BuildContext context, currentStudent, currentLesson,
      classProviderHolder) {
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("ביטול"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("מחק"),
      onPressed: () async {
        Navigator.of(context).pop();
        await classProviderHolder.setPupilClass(
            currentStudent, true, currentLesson);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("מחיקת תלמיד משיעור"),
      content: Text("לא ניתן לשחזר פעולה זו"),
      actions: [cancelButton, continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showStudentSelector(classProviderHolder, currentId, context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        List expensionStatus =
            new List.filled(classProviderHolder.classesList.data.length, false);
        bool _isLoadingModal = false;
        return StatefulBuilder(builder: (context, setState) {
          var classProviderHolder = context.watch<ClassProvider>();

          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text("סיימתי"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              _isLoadingModal
                  ? Container(width: 300, child: LinearProgressIndicator())
                  : Container()
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                        itemCount: classProviderHolder.classesList.data.length,
                        itemBuilder: (context, i) {
                          //expensionStatus.add(false);
                          return Column(
                            children: [
                              GestureDetector(
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.school),
                                    title: Text(classProviderHolder.classesList
                                        .data[i].student_class_text),
                                    trailing: Icon(Icons.more_vert),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    expensionStatus[i] = !expensionStatus[i];
                                  });
                                },
                              ),
                              expensionStatus[i] == null || !expensionStatus[i]
                                  ? Container()
                                  : FutureBuilder(
                                      builder: (context, projectSnap) {
                                        if (!projectSnap.hasData ||
                                            projectSnap.data.isEmpty)
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        else
                                          currentStudents = projectSnap.data
                                              .where((f) => f['isTeacher'] == 0)
                                              .toList();
                                        return Container(
                                          height: 200,
                                          width: 250,
                                          child: ListView.builder(
                                              itemCount: currentStudents.length,
                                              itemBuilder: (context, i) {
                                                return CheckboxListTile(
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Text(currentStudents[i]
                                                          ['firstName'] +
                                                      ' ' +
                                                      currentStudents[i]
                                                          ['lastName']),
                                                  value: currentLesson.pupils
                                                              .where((f) =>
                                                                  f.student_login_id ==
                                                                  currentStudents[
                                                                          i][
                                                                      'identitynumber'])
                                                              .toList()
                                                              .length >
                                                          0
                                                      ? true
                                                      : false,
                                                  onChanged:
                                                      (bool value) async {
                                                    setState(() {
                                                      _isLoadingModal = true;
                                                    });
                                                    await classProviderHolder
                                                        .setPupilClass(
                                                            currentStudents[i],
                                                            !value,
                                                            currentLesson);
                                                    setState(() {
                                                      _isLoadingModal = false;
                                                    });
                                                  },
                                                );
                                              }),
                                        );
                                      },
                                      future:
                                          classProviderHolder.getStudentList(
                                              classProviderHolder.classesList
                                                  .data[i].student_class_num,
                                              classProviderHolder.classesList
                                                  .data[i].student_class),
                                    )
                            ],
                          );
                          /*
                         
                          
                          ExpansionTile(
                            onExpansionChanged: (value) {
                              value = true;
                            },
                            trailing: new IconButton(
                              icon: new Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                            title: Text(
                              classProviderHolder
                                  .classesList.data[i].student_class_text,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            children: [
                              FutureBuilder(
                                builder: (context, projectSnap) {
                                  if (!projectSnap.hasData ||
                                      projectSnap.data.isEmpty)
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Center(child: CircularProgressIndicator()),
                                    );
                                  else
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      child: ListView.builder(
                                          itemCount: projectSnap.data.length,
                                          itemBuilder: (context, i) {
                                            return 
                                          }),
                                    );
                                },
                                future: classProviderHolder.getStudentList(),
                              )
                            ],
                          );
                          */
                        }),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();
    List<DataColumn> headerWidget = [];
    List<DataRow> bodyWidget = [];

    // get current lessons selected
    currentLesson = classProviderHolder.dayInfo.data
        .singleWhere((element) => element.id == widget.currentId);

    _getCellInfo(i, j) {
      if (classProviderHolder.dayInfo.eventTypes[i].id == "comment") {
        return Container(
          width: 300,
          child: TextFormField(
            initialValue: classProviderHolder.studentValue(
                currentLesson.pupils[j].student_login_id,
                classProviderHolder.dayInfo.eventTypes[i].id,
                widget.currentId),
            onChanged: (changedText) async {
              await classProviderHolder.updateStudentValue(
                  widget.currentId,
                  currentLesson.pupils[j].student_login_id,
                  classProviderHolder.dayInfo.eventTypes[i].id,
                  changedText,
                  "text");
            },
            style: TextStyle(fontSize: 18),
          ),
        );
      } else {
        return Checkbox(
          value: classProviderHolder.studentValue(
              currentLesson.pupils[j].student_login_id,
              classProviderHolder.dayInfo.eventTypes[i].id,
              widget.currentId),
          onChanged: (bool newValue) async {
            await classProviderHolder.updateStudentValue(
                widget.currentId,
                currentLesson.pupils[j].student_login_id,
                classProviderHolder.dayInfo.eventTypes[i].id,
                newValue,
                "checkbox");
          },
        );
      }
    }

    _getShownBodyAbsent(index, isPartani) {
      Widget widget;
      widget = Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              width: 80,
              child: Text(
                currentLesson.pupils[index].student_f_name +
                    " " +
                    currentLesson.pupils[index].student_l_name,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
              child: Center(
                  child: Text(
            "נעדר",
            style: TextStyle(color: Colors.red),
          )))
        ],
      );

      return widget;
    }

    _getShownBody(index) {
      List<Widget> widgets = [];
      for (var i = 0; i < 4; i++) {
        if (i == 0) {
          widgets.add(Container(
            width: 80,
            child: Text(
              currentLesson.pupils[index].student_f_name +
                  " " +
                  currentLesson.pupils[index].student_l_name,
              style: TextStyle(fontSize: 12),
            ),
          ));
        }
        widgets.add(_getCellInfo(i, index));
      }

      return widgets;
    }

    _getHeader() {
      List<Widget> widgets = [];
      for (var i = 0; i < 4; i++) {
        if (i == 0) {
          widgets.add(Container(
            width: 80,
            child: Text(
              'שם התלמיד',
              style: TextStyle(fontSize: 14),
            ),
          ));
        }
        widgets.add(Text(
          classProviderHolder.dayInfo.eventTypes[i].name,
          textAlign: TextAlign.right,
        ));
      }
      return widgets;
    }

    _getHiddenBodyAbsent(isAbsent) {
      List<Widget> widgets = [];
      widgets.add(Container(
        child: Text(isAbsent[0].reason),
      ));
      return widgets;
    }

    _getHiddenBody(index) {
      List<Widget> widgets = [];
      for (var i = 4; i < classProviderHolder.dayInfo.eventTypes.length; i++) {
        widgets.add(ListTile(
          leading: classProviderHolder.dayInfo.eventTypes[i].id == "comment"
              ? null
              : _getCellInfo(i, index),
          title: Text(classProviderHolder.dayInfo.eventTypes[i].name),
          trailing: classProviderHolder.dayInfo.eventTypes[i].id != "comment"
              ? null
              : _getCellInfo(i, index),
        ));
      }
      return widgets;
    }

    return Scaffold(
      body: Stack(children: <Widget>[
        classProviderHolder.showPreloader
            ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[CircularProgressIndicator()],
                  ),
                ),
              )
            : Container(),
        Column(
          children: [
            currentLesson.isPartani
                ? Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'ניתן להוסיף תלמיד בלחיצה על הפלוס הכחול ניתן להסיר תלמיד בלחיצה רציפה על שמו'),
                    ),
                  )
                : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: currentLesson.pupils.length,
                itemBuilder: (context, i) {
                  Iterable<AbsentPupil> isAbsent;
                  isAbsent = classProviderHolder
                      .isAbsent(currentLesson.pupils[i])
                      .toList();

                  return GestureDetector(
                    onLongPress: currentLesson.isPartani
                        ? () {
                            _showDeleteConfirmDialog(
                                context,
                                currentLesson.pupils[i],
                                currentLesson,
                                classProviderHolder);
                          }
                        : null,
                    child: Column(
                      children: [
                        i == 0
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: 10, left: 70, top: 20, bottom: 5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: _getHeader().toList()),
                              )
                            : Container(),
                        ListTileTheme(
                          contentPadding: EdgeInsets.all(0),
                          child: ExpansionTile(
                            title: isAbsent.length == 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: _getShownBody(i).toList())
                                : _getShownBodyAbsent(
                                    i, currentLesson.isPartani),
                            backgroundColor: Theme.of(context)
                                .accentColor
                                .withOpacity(0.025),
                            children: isAbsent.length == 0
                                ? _getHiddenBody(i).toList()
                                : _getHiddenBodyAbsent(isAbsent),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ]),
      floatingActionButton: currentLesson.isPartani
          ? FloatingActionButton(
              onPressed: () async {
                await classProviderHolder.getClassesList();
                _showStudentSelector(
                    classProviderHolder, widget.currentId, context);
              },
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}
