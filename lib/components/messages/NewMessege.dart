import 'dart:ui';

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
import 'package:flutter_tags/flutter_tags.dart';

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
  final messegeInfo;
  final prevMailProviderHolder;
  NewMessege(
      {this.reply,
      this.replyToAll,
      this.messegeInfo,
      this.prevMailProviderHolder});

  @override
  _NewMessegeState createState() => _NewMessegeState();
}

class _NewMessegeState extends State<NewMessege> {
  @override
  void initState() {
    if (widget.prevMailProviderHolder != null &&
        widget.prevMailProviderHolder.recep.length > 0) {
      widget.prevMailProviderHolder.clearRecap();
    }

    super.initState();
  }

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  int tag;
  final subject = TextEditingController();
  final content = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          var mailProviderHolder = ctx.watch<MailProvider>();

          return mailProviderHolder.groupsList != null
              ? Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ListView(
                      children: mailProviderHolder.groupsList.data.map((item) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    new Checkbox(
                                      value: item.selected,
                                      onChanged: (bool value) async {
                                        await mailProviderHolder
                                            .setGroupSelected(item.key);
                                      },
                                    ),
                                    Text(item.name),
                                  ],
                                ),
                                GestureDetector(
                                    child: Icon(item.shown
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down),
                                    onTap: () async {
                                      await mailProviderHolder
                                          .setGroupShownHidden(item.key);
                                    })
                              ],
                            ),
                            item.shown
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Container(
                                        height: 200,
                                        child: mailProviderHolder
                                                            .GroupMembersList[
                                                        item.key] !=
                                                    null &&
                                                mailProviderHolder
                                                        .GroupMembersList[
                                                            item.key]
                                                        .data
                                                        .length >
                                                    0
                                            ? ListView(
                                                children: mailProviderHolder
                                                    .GroupMembersList[item.key]
                                                    .data
                                                    .map<Widget>(
                                                      (elem) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                elem.selected,
                                                            onChanged:
                                                                (bool value) {
                                                              mailProviderHolder
                                                                  .setMemberSelected(
                                                                      item.key,
                                                                      elem.identitynumber);
                                                            },
                                                          ),
                                                          Text(
                                                              '${elem.firstName} ${elem.lastName}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                        ],
                                                      ),
                                                    )
                                                    .toList())
                                            : Center(
                                                child:
                                                    CircularProgressIndicator())),
                                  )
                                : Container(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  mailProviderHolder.showPreloader
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
                ])
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'הודעה חדשה',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attachment),
            onPressed: () async {
              FilePickerResult filesPathsRes =
                  await FilePicker.platform.pickFiles();
              if (mailProviderHolder.filePathes != null &&
                  mailProviderHolder.filePathes.length < 3 &&
                  filesPathsRes != null) {
                mailProviderHolder
                    .addToFilePath(filesPathsRes.files.single.path);
              } else if (mailProviderHolder.filePathes.length == 3) {
                showToastUpload("עד 3 קבצים");
              }
              print(mailProviderHolder.filePathes);
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              final pickedFile =
                  await picker.getImage(source: ImageSource.camera);
              if (mailProviderHolder.filePathes != null &&
                  mailProviderHolder.filePathes.length < 3 &&
                  pickedFile != null) {
                mailProviderHolder.addToFilePath(pickedFile.path);
              } else if (mailProviderHolder.filePathes.length == 3) {
                showToastUpload("עד 3 קבצים");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (mailProviderHolder.recep.length == 0) {
                  showToastUpload("יש לבחור נמענים");
                  displayBottomSheet(context);
                  return;
                }
                var sendStatus = await mailProviderHolder.sendMessege(
                  subject.text,
                  content.text,
                  widget.reply,
                  widget.replyToAll,
                  widget.messegeInfo != null
                      ? widget.messegeInfo.messageID
                      : null,
                );
                if (sendStatus) {
                  Navigator.pop(context);
                  showToastUpload("ההודעה נשלחה בהצלחה");
                }
              }
            },
          ),
          PopUpMenu(),
        ],
      ),
      body: Stack(children: [
        Padding(
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
                        mailProviderHolder.setSelectedTag(value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'יש לבחור קטגוריה';
                        }
                        return null;
                      }),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ל"),
                        Expanded(
                            child: Tags(
                                horizontalScroll: true,
                                itemCount: mailProviderHolder.recep.length,
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
                                    removeButton:
                                        !widget.reply && !widget.replyToAll
                                            ? ItemTagsRemoveButton(
                                                onRemoved: () {
                                                  mailProviderHolder
                                                      .setMemberSelected(
                                                          mailProviderHolder
                                                                  .getRecepList()[
                                                              index][1][1],
                                                          mailProviderHolder
                                                                  .getRecepList()[
                                                              index][0]);
                                                  return true;
                                                },
                                              )
                                            : null,
                                    title:
                                        ' ${mailProviderHolder.getRecepList()[index][1][0]}  ',
                                  );
                                })),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: !widget.reply && !widget.replyToAll
                              ? () async {
                                  displayBottomSheet(context);
                                }
                              : null,
                        ),
                      ]),
                  Divider(),
                  Expanded(
                    child: TextField(
                      controller: content,
                      maxLines: 60,
                      decoration:
                          InputDecoration.collapsed(hintText: "כתיבת אימייל"),
                    ),
                  ),
                  Expanded(
                    child: mailProviderHolder.filePathes != null &&
                            mailProviderHolder.filePathes.length > 0
                        ? ListView.builder(
                            itemCount: mailProviderHolder.filePathes.length,
                            itemBuilder: (context, i) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FileViewer(
                                              mailProviderHolder
                                                  .filePathes[i])),
                                    );
                                  },
                                  leading: GestureDetector(
                                    child: Icon(Icons.delete),
                                    onTap: () {
                                      mailProviderHolder.removeFromFilePath(i);
                                    },
                                  ),
                                  title: Text(mailProviderHolder.filePathes[i]
                                      .split("/")
                                      .last),
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
        mailProviderHolder.showPreloader
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
    );
  }
}
