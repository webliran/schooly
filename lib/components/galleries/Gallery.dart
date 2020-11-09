import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:schooly/providers/gallery.provider.dart';
import 'package:provider/provider.dart';

class Gallery extends StatelessWidget {
  final galleryId;
  Gallery({this.galleryId});

  @override
  Widget build(BuildContext context) {
    var galleryProviderHolder = context.watch<GalleryProvider>();
    var currentGallery = galleryProviderHolder.galleries.data
        .where((element) => element.id == galleryId)
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(child: Text(currentGallery[0].name)),
        actions: <Widget>[
          PopUpMenu(),
        ],
      ),
      body: Container(
          child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage(currentGallery[0].imagesList[index].url),
            initialScale: PhotoViewComputedScale.contained,
          );
        },
        itemCount: currentGallery[0].imagesList.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      )),
    );
  }
}
