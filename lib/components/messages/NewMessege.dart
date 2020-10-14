import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/mail.provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

showToastUpload(msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    webBgColor: "#e74c3c",
    timeInSecForIosWeb: 3,
  );
}

class NewMessege extends StatefulWidget {
  final bool reply;
  final bool replyToAll;
  final messegeId;
  NewMessege({this.reply, this.replyToAll, this.messegeId});

  @override
  _NewMessegeState createState() => _NewMessegeState();
}

class _NewMessegeState extends State<NewMessege> {
  final picker = ImagePicker();
  List filesPaths = [];
  List to = [];
  int tag;
  var subject = TextEditingController();
  var content = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          var mailProviderHolder = ctx.watch<MailProvider>();

          return mailProviderHolder.groupsList != null
              ? ListView(
                  children: mailProviderHolder.groupsList.data.map((item) {
                    return Column(
                      children: [
                        new CheckboxListTile(
                          secondary: GestureDetector(
                              child: Icon(Icons.arrow_drop_down_circle),
                              onTap: () {
                                mailProviderHolder
                                    .setGroupShownHidden(item.key);
                              }),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: new Text(item.name),
                          value: item.selected,
                          onChanged: (bool value) {
                            mailProviderHolder.setGroupSelected(item.key);
                          },
                        ),
                        Container(
                            height: 200,
                            child: item.shown
                                ? ListView(
                                    children: mailProviderHolder
                                        .GroupMembersList[item.key].data
                                        .map<Widget>(
                                          (elem) => CheckboxListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: new Text(
                                                '${elem.firstName} ${elem.lastName}'),
                                            value: elem.selected,
                                            onChanged: (bool value) {},
                                          ),
                                        )
                                        .toList())
                                : Container())
                      ],
                    );
                  }).toList(),
                )
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הודעה חדשה',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attachment),
            onPressed: () async {
              var filesPathsRes = await FilePicker.getFilePath();
              if (filesPaths == null || filesPaths.length < 3) {
                setState(() {
                  filesPaths.add(filesPathsRes);
                });
              } else {
                showToastUpload("עד 3 קבצים");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              final pickedFile =
                  await picker.getImage(source: ImageSource.camera);
              if (filesPaths == null || filesPaths.length < 3) {
                setState(() {
                  filesPaths.add(pickedFile.path);
                });
              } else {
                showToastUpload("עד 3 קבצים");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (to.length == 0) {
                  showToastUpload("יש לבחור נמענים");
                  displayBottomSheet(context);
                  return;
                }
                mailProviderHolder.sendMessege(
                    subject.text,
                    content.text,
                    filesPaths,
                    widget.reply,
                    widget.replyToAll,
                    widget.messegeId);
              }
            },
          ),
          PopUpMenu(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: subject,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelText: 'נושא',
                  ),
                ),
                Divider(
                  height: 5,
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    isExpanded: true,
                    value: tag,
                    hint: Text('יש לבחור קטגוריה'),
                    items: mailProviderHolder.tagsList != null
                        ? mailProviderHolder.tagsList.data.map((elem) {
                            return DropdownMenuItem(
                              child: Text(elem.name),
                              value: elem.id,
                            );
                          }).toList()
                        : [],
                    onChanged: (value) {
                      setState(() {
                        tag = value;
                      });
                    },
                    validator: (value) {
                      print(value);
                      if (value == null) {
                        return 'יש לבחור קטגוריה';
                      }
                      return null;
                    }),
                Divider(),
                !widget.reply && !widget.replyToAll
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("ל"),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                displayBottomSheet(context);
                              },
                            ),
                          ])
                    : Container(),
                Divider(),
                Expanded(
                  child: TextField(
                    controller: content,
                    maxLines: 8,
                    decoration:
                        InputDecoration.collapsed(hintText: "כתיבת אימייל"),
                  ),
                ),
                Expanded(
                  child: filesPaths.length > 0
                      ? ListView.builder(
                          itemCount: filesPaths.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FileViewer(filesPaths[i])),
                                  );
                                },
                                leading: GestureDetector(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    setState(() {
                                      filesPaths.removeAt(i);
                                    });
                                  },
                                ),
                                title: Text(filesPaths[i].split("/").last),
                              ),
                            );

                            //path.extension(currentLesson.hFiles[i])
                          })
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
