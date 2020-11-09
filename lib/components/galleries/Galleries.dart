import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:schooly/components/galleries/Gallery.dart';
import 'package:schooly/components/galleries/Likes.dart';
import 'package:schooly/components/galleries/NewGallery.dart';
import 'package:schooly/components/galleries/Responses.dart';
import 'package:schooly/components/global/AlertPop.dart';
import 'package:schooly/components/global/PopupMenuMain.dart';
import 'package:schooly/providers/gallery.provider.dart';
import 'package:provider/provider.dart';

class Galleries extends StatefulWidget {
  @override
  _GalleriesState createState() => _GalleriesState();
}

class _GalleriesState extends State<Galleries> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void displayBottomSheet(BuildContext context, type, id) {
    Widget widgetToShow;
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          var galleryProviderHolder = ctx.watch<GalleryProvider>();

          if (type == "repsonse") {
            widgetToShow = Responses(
              id: id,
              oldGalleryProviderHolder: galleryProviderHolder,
            );
          } else if (type == "likes") {
            widgetToShow = Likes(
              id: id,
              oldGalleryProviderHolder: galleryProviderHolder,
            );
          }
          return Stack(children: [
            widgetToShow,
            galleryProviderHolder.showPreloader
                ? Align(
                    alignment: Alignment.topCenter,
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
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    var galleryProviderHolder = context.watch<GalleryProvider>();
    void _onRefresh() async {
      await galleryProviderHolder.getGalleries();
      await _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      await galleryProviderHolder.getGalleries();
      _refreshController.loadComplete();
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('גלריות')),
          actions: <Widget>[
            PopUpMenu(),
          ],
        ),
        body: Stack(children: [
          galleryProviderHolder.galleries != null
              ? Container(
                  child: galleryProviderHolder.galleries.data.length > 0
                      ? SmartRefresher(
                          // senablePullDown: true,
                          enablePullUp: true,
                          header: CustomHeader(builder:
                              (BuildContext context, RefreshStatus mode) {
                            return Center(child: CircularProgressIndicator());
                          }),
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus mode) {
                              return mode == LoadStatus.loading
                                  ? Center(child: CircularProgressIndicator())
                                  : Container();
                            },
                          ),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: ListView.builder(
                              itemCount:
                                  galleryProviderHolder.galleries.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await galleryProviderHolder.getGallery(
                                        galleryProviderHolder
                                            .galleries.data[index].id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Gallery(
                                              galleryId: galleryProviderHolder
                                                  .galleries.data[index].id);
                                        },
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: galleryProviderHolder.isOwner(
                                                    galleryProviderHolder
                                                        .galleries
                                                        .data[index]
                                                        .student_id) &&
                                                galleryProviderHolder.isOwner(
                                                        galleryProviderHolder
                                                            .galleries
                                                            .data[index]
                                                            .student_id) !=
                                                    null
                                            ? IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  showAlertDialog(
                                                      context,
                                                      "מחיקת גלריה",
                                                      "האם אתה בטוח?",
                                                      () => galleryProviderHolder
                                                          .deleteGallery(
                                                              galleryProviderHolder
                                                                  .galleries
                                                                  .data[index]
                                                                  .id),
                                                      false);
                                                })
                                            : SizedBox(),
                                      ),
                                      Text(
                                        galleryProviderHolder
                                            .galleries.data[index].name,
                                        style: TextStyle(fontSize: 28),
                                      ),
                                      Text(
                                          '(${galleryProviderHolder.galleries.data[index].firstName} ${galleryProviderHolder.galleries.data[index].lastName})'),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          height: 250,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          imageUrl: galleryProviderHolder
                                              .galleries.data[index].image.url,
                                          placeholder: (context, url) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              SizedBox(
                                            height: 250,
                                          ),
                                        ),
                                      ),
                                      galleryProviderHolder
                                                  .getAvailbleClasses(index)
                                                  .length >
                                              0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Tags(
                                                  horizontalScroll: true,
                                                  alignment:
                                                      WrapAlignment.spaceAround,
                                                  itemCount:
                                                      galleryProviderHolder
                                                          .getAvailbleClasses(
                                                              index)
                                                          .length,
                                                  itemBuilder: (i) {
                                                    return ItemTags(
                                                        textStyle: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                        activeColor:
                                                            Colors.green[400],
                                                        color:
                                                            Colors.green[400],
                                                        textActiveColor:
                                                            Colors.white,
                                                        textColor: Colors.white,
                                                        index: i,
                                                        title: galleryProviderHolder
                                                            .getAvailbleClasses(
                                                                index)[i]);
                                                  }),
                                            )
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    galleryProviderHolder
                                                        .galleries
                                                        .data[index]
                                                        .date)),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: galleryProviderHolder
                                                            .galleries
                                                            .data[index]
                                                            .canLike
                                                        ? Colors.grey
                                                        : Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    if (galleryProviderHolder
                                                        .galleries
                                                        .data[index]
                                                        .canLike) {
                                                      await galleryProviderHolder
                                                          .setGalleryLike(
                                                              galleryProviderHolder
                                                                  .galleries
                                                                  .data[index]
                                                                  .id);
                                                    } else {
                                                      galleryProviderHolder
                                                          .getLikes(
                                                              galleryProviderHolder
                                                                  .galleries
                                                                  .data[index]
                                                                  .id);
                                                      displayBottomSheet(
                                                          context,
                                                          "likes",
                                                          galleryProviderHolder
                                                              .galleries
                                                              .data[index]
                                                              .id);
                                                    }
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                                Text(galleryProviderHolder
                                                    .galleries.data[index].likes
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.comment),
                                                  color: Colors.black,
                                                  onPressed: () async {
                                                    galleryProviderHolder
                                                        .getResponses(
                                                            galleryProviderHolder
                                                                .galleries
                                                                .data[index]
                                                                .id);
                                                    displayBottomSheet(
                                                        context,
                                                        "repsonse",
                                                        galleryProviderHolder
                                                            .galleries
                                                            .data[index]
                                                            .id);
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                                Text(galleryProviderHolder
                                                    .galleries
                                                    .data[index]
                                                    .responses
                                                    .toString())
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                        thickness: 2,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Text('אין גלריות'))
              : Center(child: CircularProgressIndicator()),
          galleryProviderHolder.showPreloader
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  galleryProviderHolder.clearNewGallery();
                  return NewGallery();
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
