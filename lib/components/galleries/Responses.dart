import 'package:flutter/material.dart';
import 'package:schooly/providers/gallery.provider.dart';
import 'package:provider/provider.dart';

class Responses extends StatefulWidget {
  final id;
  final oldGalleryProviderHolder;
  Responses({this.id, this.oldGalleryProviderHolder});

  @override
  _ResponsesState createState() => _ResponsesState();
}

class _ResponsesState extends State<Responses> {
  final response = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var galleryProviderHolder = context.watch<GalleryProvider>();

    var currentGallery = galleryProviderHolder.galleries.data
        .where((element) => element.id == widget.id)
        .toList();

    return Column(children: [
      TextField(
        controller: response,
        decoration: InputDecoration(
          labelText: 'טקסט תגובה',
        ),
      ),
      RaisedButton(
        onPressed: () async {
          await galleryProviderHolder.setGalleryResponse(
              widget.id, response.text);
          response.text = "";
        },
        child: Text("שלח", style: TextStyle(color: Colors.white)),
      ),
      currentGallery[0].responsesList != null
          ? Expanded(
              child: Container(
                height: 300,
                child: currentGallery[0].responsesList.length > 0
                    ? ListView.builder(
                        itemCount: currentGallery[0].responsesList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Column(
                            children: [
                              ListTile(
                                subtitle: Text(
                                  '${currentGallery[0].responsesList[index].firstName} ${currentGallery[0].responsesList[index].lastName}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                title: Text(currentGallery[0]
                                    .responsesList[index]
                                    .response),
                                leading: Icon(Icons.comment_rounded),
                              ),
                              Divider()
                            ],
                          );
                        })
                    : Text('אין תגובות'),
              ),
            )
          : Container(),
    ]);
  }
}
