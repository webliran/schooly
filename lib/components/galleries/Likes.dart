import 'package:flutter/material.dart';
import 'package:schooly/providers/gallery.provider.dart';
import 'package:provider/provider.dart';

class Likes extends StatefulWidget {
  final id;
  final oldGalleryProviderHolder;
  Likes({this.id, this.oldGalleryProviderHolder});

  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    var galleryProviderHolder = context.watch<GalleryProvider>();
    var currentGallery = galleryProviderHolder.galleries.data
        .where((element) => element.id == widget.id)
        .toList();

    return Column(children: [
      currentGallery[0].likesList != null
          ? Container(
              height: 300,
              child: currentGallery[0].likesList.length > 0
                  ? ListView.builder(
                      itemCount: currentGallery[0].likesList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                '${currentGallery[0].likesList[index].firstName} ${currentGallery[0].likesList[index].lastName}',
                                style: TextStyle(fontSize: 20),
                              ),
                              leading: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                            Divider()
                          ],
                        );
                      })
                  : Text('אין לייקים'),
            )
          : Container(),
    ]);
  }
}
