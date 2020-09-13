import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/providers/classes.provider.dart';

class HomeWork extends StatefulWidget {
  final String currentId;

  HomeWork({this.currentId});
  @override
  _HomeWorkState createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  @override
  ScrollController scrollController;
  bool dialVisible = true;
  var currentLesson;
  final picker = ImagePicker();

  List filesPaths;

  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }

  @override
  SafeArea buildSpeedDial(classProviderHolder, currentClass) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SpeedDial(
          marginRight: 40,
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 30.0),
          // child: Icon(Icons.add),
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          visible: dialVisible,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.deepOrange,
              onTap: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);
                print(pickedFile.path);
                classProviderHolder
                    .updateFilesHomeWork(currentClass, [pickedFile.path]);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.file_upload),
              backgroundColor: Colors.green,
              onTap: () async {
                var filesPathsRes = await FilePicker.getMultiFilePath();
                filesPaths = filesPathsRes.values.toList();
                classProviderHolder.updateFilesHomeWork(
                    currentClass, filesPaths);

                /*
                await classProviderHolder.uploadFIlesHomeWork(
                    filesPaths.values.toList(), currentClassId);
                */
              },
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();
// get current lessons selected
    currentLesson = classProviderHolder.dayInfo.data
        .singleWhere((element) => element.id == widget.currentId);

    var titleController = TextEditingController();
    var hContentController = TextEditingController();

    titleController.text = currentLesson.subject;
    hContentController.text = currentLesson.hContent;

    return Scaffold(
        body: Stack(children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'נושא השיעור',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: hContentController,
                        maxLines: 8,
                        decoration: InputDecoration.collapsed(
                            hintText: "הכנס טקסט כאן..."),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: currentLesson.hFiles.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FileViewer(currentLesson.hFiles[i]),
                                  ),
                                );
                              },
                              leading: GestureDetector(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  classProviderHolder.removeFileHomeWork(
                                      currentLesson, i);
                                },
                              ),
                              title:
                                  Text(currentLesson.hFiles[i].split("/").last),
                            ),
                          );

                          //path.extension(currentLesson.hFiles[i])
                        }),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      currentLesson.subject = titleController.text;
                      currentLesson.hContent = hContentController.text;
                      classProviderHolder.uploadFIlesAndInfoHomeWork(
                          currentLesson, currentLesson.id);
                    },
                    child: Text('עדכון'),
                  ),
                ],
              ),
            ),
          ),
          classProviderHolder.showPreloader
              ? Align(
                  alignment: Alignment.bottomLeft,
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
              : Container()
        ]),
        floatingActionButton:
            buildSpeedDial(classProviderHolder, currentLesson));
  }
}
