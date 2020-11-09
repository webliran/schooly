import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/events.provider.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  int tag;
  final title = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }

  showToastUpload(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      webBgColor: "#e74c3c",
      timeInSecForIosWeb: 3,
    );
  }

  void displayBottomSheet(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    var eventsProviderHolder = context.watch<EventsProvider>();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'גלריה חדשה',
        ),
      ),
      body: Stack(children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: title,
                      decoration: InputDecoration(hintText: 'שם הגלריה'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'יש להזין שם גלריה';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ל"),
                          Expanded(
                              child: Tags(
                                  horizontalScroll: true,
                                  itemCount: eventsProviderHolder
                                      .classesList.data
                                      .where((element) => element.selected)
                                      .toList()
                                      .length,
                                  itemBuilder: (index) {
                                    return ItemTags(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      activeColor: Colors.green[400],
                                      color: Colors.green[400],
                                      textActiveColor: Colors.white,
                                      textColor: Colors.white,
                                      index: index,
                                      title: eventsProviderHolder.classesList
                                          .data[index].student_class_text,
                                    );
                                  })),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                displayBottomSheet(context);
                              }),
                        ]),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                            child: Icon(Icons.image),
                            color: Colors.white,
                            onPressed: () async {
                              FilePickerResult filesPathsRes =
                                  await FilePicker.platform.pickFiles(
                                      allowMultiple: true,
                                      type: FileType.image);

                              filesPathsRes.paths.forEach((value) {
                                eventsProviderHolder.addFilesToPaths(value);
                              });
                            }),
                        RaisedButton(
                            child: Icon(Icons.camera_alt),
                            color: Colors.white,
                            onPressed: () async {
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.camera);
                              eventsProviderHolder
                                  .addFilesToPaths(pickedFile.path);
                            })
                      ],
                    ),
                    Expanded(
                      child: eventsProviderHolder.filePathes != null &&
                              eventsProviderHolder.filePathes.length > 0
                          ? ListView.builder(
                              itemCount: eventsProviderHolder.filePathes.length,
                              itemBuilder: (context, i) {
                                return Stack(children: [
                                  ListTile(
                                    onTap: () {},
                                    title: Image.asset(
                                      eventsProviderHolder.filePathes[i],
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          eventsProviderHolder
                                              .removeFilesToPaths(i);
                                        }),
                                  )
                                ]);

                                //path.extension(currentLesson.hFiles[i])
                              })
                          : Container(),
                    ),
                  ],
                ),
              ),
            )),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (eventsProviderHolder.classesList.data
                          .where((element) => element.selected)
                          .toList()
                          .length ==
                      0) {
                    showToastUpload("יש לבחור נמענים");
                    displayBottomSheet(context);
                    return;
                  }
                  /*if (eventsProviderHolder.filePathes.length == 0) {
                    showToastUpload("יש להעלות לפחות קובץ אחד");
                    return;
                  }*/
                  var createStatus = true;

                  if (createStatus) {
                    Navigator.pop(context);
                    showToastUpload("הגלריה נוצרה בהצלחה");
                  }
                }
              },
              child: Text(
                "צור גלריה",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        eventsProviderHolder.showPreloader
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
            : Container()
      ]),
    );
  }
}
