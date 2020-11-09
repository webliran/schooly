import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schooly/providers/gallery.provider.dart';

class NewGallery extends StatefulWidget {
  @override
  _NewGalleryState createState() => _NewGalleryState();
}

class _NewGalleryState extends State<NewGallery> {
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

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          var galleryProviderHolder = ctx.watch<GalleryProvider>();
          var widgetTree = galleryProviderHolder.classesList.data.map((item) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        new Checkbox(
                          value: item.selected,
                          onChanged: galleryProviderHolder.sendToAll == 1
                              ? null
                              : (bool value) async {
                                  await galleryProviderHolder.setGroupSelected(
                                      item.value, value);
                                },
                        ),
                        Text(item.student_class_text),
                      ],
                    )
                  ],
                )
              ],
            );
          }).toList();
          widgetTree.insert(
              0,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          new Checkbox(
                            value: galleryProviderHolder.sendToAll == 1,
                            onChanged: (bool value) async {
                              await galleryProviderHolder
                                  .setGroupSelectedAll(value);
                            },
                          ),
                          Text('כולם'),
                        ],
                      )
                    ],
                  )
                ],
              ));

          return galleryProviderHolder.classesList != null
              ? Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ListView(
                      children: widgetTree,
                    ),
                  ),
                  galleryProviderHolder.showPreloader
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
    var galleryProviderHolder = context.watch<GalleryProvider>();

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
                                  itemCount: galleryProviderHolder
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
                                      title: galleryProviderHolder.classesList
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
                                galleryProviderHolder.addFilesToPaths(value);
                              });
                            }),
                        RaisedButton(
                            child: Icon(Icons.camera_alt),
                            color: Colors.white,
                            onPressed: () async {
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.camera);
                              galleryProviderHolder
                                  .addFilesToPaths(pickedFile.path);
                            })
                      ],
                    ),
                    Expanded(
                      child: galleryProviderHolder.filePathes != null &&
                              galleryProviderHolder.filePathes.length > 0
                          ? ListView.builder(
                              itemCount:
                                  galleryProviderHolder.filePathes.length,
                              itemBuilder: (context, i) {
                                return Stack(children: [
                                  ListTile(
                                    onTap: () {},
                                    title: Image.asset(
                                      galleryProviderHolder.filePathes[i],
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
                                          galleryProviderHolder
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
                  if (galleryProviderHolder.classesList.data
                          .where((element) => element.selected)
                          .toList()
                          .length ==
                      0) {
                    showToastUpload("יש לבחור נמענים");
                    displayBottomSheet(context);
                    return;
                  }
                  /*if (galleryProviderHolder.filePathes.length == 0) {
                    showToastUpload("יש להעלות לפחות קובץ אחד");
                    return;
                  }*/
                  var createStatus = await galleryProviderHolder
                      .createUploadFIlesGallery(title.text);
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
        galleryProviderHolder.showPreloader
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
