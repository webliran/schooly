import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:schooly/models/gallery/gallery.dart';
import 'package:schooly/models/mail/mailinfo.dart';
import 'package:schooly/providers/schooly.provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooly/providers/sharedstate.dart';
import 'package:schooly/models/translate.dart';

class GalleryProvider extends SchoolyApi with ChangeNotifier {
  String msg;
  String uuid;
  String studentId;
  bool showPreloader = false;
  String currentFirstName;
  String currentLastName;
  GelleriesList galleries;
  List filePathes = [];
  ClassesList classesList;
  int sendToAll = 0;

  GalleryProvider() {
    setMainInfo();
  }
  void setShowPreloader() {
    showPreloader = true;
    notifyListeners();
  }

  void setHidePreloader() {
    showPreloader = false;
    notifyListeners();
  }

  void showWebColoredToast() {
    String msgFinal = Translate().translations[msg] != ""
        ? Translate().translations[msg]
        : msg;
    Fluttertoast.showToast(
      msg: msgFinal,
      toastLength: Toast.LENGTH_LONG,
      webBgColor: "#e74c3c",
      timeInSecForIosWeb: 5,
    );
  }

  void setMainInfo() async {
    uuid = await SharedState().read('uuid');
    studentId = await SharedState().read('studentId');
    await getGroups();
    await getGalleries();
  }

  bool isOwner(stdid) {
    if (studentId == stdid) {
      return true;
    }

    return false;
  }

  getGalleries() async {
    print('$url/?query=GetGalleries&uuid=$uuid');
    var galleriesResponse =
        await http.get('$url/?query=GetUserGalleries&uuid=$uuid');
    if (galleriesResponse.statusCode == 200) {
      var galleriesJsonResponse = convert.jsonDecode(galleriesResponse.body);
      if (galleriesJsonResponse['success']) {
        galleries = new GelleriesList.fromJson(galleriesJsonResponse);

        notifyListeners();
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  clearNewGallery() {
    filePathes.clear();
    classesList.data.forEach((element) => element.selected = false);
    sendToAll = 0;
  }

  addFilesToPaths(file) {
    filePathes.add(file);

    notifyListeners();
  }

  removeFilesToPaths(index) {
    filePathes.removeAt(index);
    notifyListeners();
  }

  createUploadFIlesGallery(title) async {
    setShowPreloader();
    String to = "";
    var currentGroup =
        classesList.data.where((element) => element.selected).toList();
    currentGroup.forEach((element) {
      to += element.value + ",";
    });
    to = to.substring(0, to.length - 1);

    var addGalleryRes =
        await http.get('$url/?query=AddGallery&uuid=$uuid&name=$title');

    if (addGalleryRes.statusCode == 200) {
      var addGalleryResponse = convert.jsonDecode(addGalleryRes.body);
      var galleryId = addGalleryResponse['data'][0]['id'];
      if (addGalleryResponse['success']) {
        var responseUpdateGallery = await http.get(
            '$url/?query=UpdateGallery&uuid=$uuid&classes=$to&name=$title&id=$galleryId');
        if (responseUpdateGallery.statusCode == 200) {
          var responseUpdateGalleryJson =
              convert.jsonDecode(responseUpdateGallery.body);

          if (responseUpdateGalleryJson['success']) {
            String uploadUrl =
                '$url/?query=UploadContentFiles&uuid=$uuid&folder=allery&id=$galleryId';

            var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

            for (var i = 0; i < filePathes.length; i++) {
              if (FileSystemEntity.typeSync(filePathes[i]) !=
                  FileSystemEntityType.notFound) {
                request.files.add(
                    await http.MultipartFile.fromPath('[${i}]', filePathes[i]));
              }
            }

            var responseFileUpload = await request.send();
            final responseFileUploadJsonFull =
                await responseFileUpload.stream.bytesToString();

            if (responseFileUpload.statusCode == 200) {
              var responseFileUploadJson =
                  convert.jsonDecode(responseFileUploadJsonFull);

              if (responseFileUploadJson['success']) {
                var filesNames = responseFileUploadJson["fileNames"];
                List files = filesNames.split(",");
                for (var i = 0; i < files.length; i++) {
                  var addGalleryImagesRes = await http.get(
                      '$url/?query=AddGalleryImage&uuid=$uuid&url=${files[i]}&id=$galleryId');

                  if (addGalleryImagesRes.statusCode == 200) {
                    var addGalleryImagesResponse =
                        convert.jsonDecode(addGalleryImagesRes.body);

                    if (addGalleryImagesResponse['success']) {}
                  }
                }
              } else {
                msg = 'NetworkError';
                showWebColoredToast();
              }
            } else {
              msg = 'NetworkError';
              showWebColoredToast();
            }
            await getGalleries();
            setHidePreloader();
            notifyListeners();
            return true;
          } else {
            msg = 'NetworkError';
            showWebColoredToast();
          }
        } else {
          msg = 'NetworkError';
          showWebColoredToast();
        }
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setGroupSelectedAll(value) {
    sendToAll = value ? 1 : 0;
    if (value) {
      classesList.data.forEach((element) {
        element.selected = true;
      });
    } else {
      classesList.data.forEach((element) {
        element.selected = false;
      });
    }

    notifyListeners();
  }

  setGroupSelected(key, value) {
    var currentGroup =
        classesList.data.where((element) => element.value == key).toList();
    currentGroup[0].selected = value;

    notifyListeners();
  }

  deleteGallery(id) async {
    setShowPreloader();
    var deleteGalleryRes =
        await http.get('$url/?query=DeleteGallery&uuid=$uuid&id=$id');
    if (deleteGalleryRes.statusCode == 200) {
      var deleteGalleryResponse = convert.jsonDecode(deleteGalleryRes.body);

      if (deleteGalleryResponse['success']) {
        galleries.data.removeWhere((element) => element.id == id);
        setHidePreloader();
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getGroups() async {
    var classesListRes = await http.get('$url/?query=GetClasses&uuid=$uuid');
    if (classesListRes.statusCode == 200) {
      var classesListResponse = convert.jsonDecode(classesListRes.body);
      if (classesListResponse['success']) {
        classesList = new ClassesList.fromJson(classesListResponse);
      } else {
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getGallery(id) async {
    setShowPreloader();
    var currentGallery =
        galleries.data.where((element) => element.id == id).toList();

    if (currentGallery[0].imagesList != null &&
        currentGallery[0].imagesList.length > 0) {
      setHidePreloader();
      notifyListeners();
      return;
    }
    var galleriesImagesResponse = await http
        .get('$url/?query=GetGalleryImages&uuid=$uuid&gallery_id=$id');
    if (galleriesImagesResponse.statusCode == 200) {
      var galleriesImagesJsonResponse =
          convert.jsonDecode(galleriesImagesResponse.body);
      if (galleriesImagesJsonResponse['success']) {
        setHidePreloader();
        var images =
            galleriesImagesJsonResponse['data'].map<GalleryImage>((elem) {
          return new GalleryImage(url: elem['url'], name: "", id: elem['id']);
        }).toList();
        currentGallery[0].imagesList = images;
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getLikes(id) async {
    setShowPreloader();
    var currentGallery =
        galleries.data.where((element) => element.id == id).toList();

    var galleryLikesResponse =
        await http.get('$url/?query=GetGalleryLikes&uuid=$uuid&gallery_id=$id');
    if (galleryLikesResponse.statusCode == 200) {
      var galleryLikesJsonResponse =
          convert.jsonDecode(galleryLikesResponse.body);
      if (galleryLikesJsonResponse['success']) {
        setHidePreloader();
        var likesList =
            galleryLikesJsonResponse['data'].map<GalleryLikes>((elem) {
          return new GalleryLikes(
              student_id: elem['student_id'],
              firstName: elem['firstName'],
              lastName: elem['lastName']);
        }).toList();

        currentGallery[0].likesList = likesList;
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  getResponses(id) async {
    setShowPreloader();
    var currentGallery =
        galleries.data.where((element) => element.id == id).toList();

    var galleryResponsesResponse = await http
        .get('$url/?query=GetGalleryResponses&uuid=$uuid&gallery_id=$id');
    if (galleryResponsesResponse.statusCode == 200) {
      var galleryResponsesJsonResponse =
          convert.jsonDecode(galleryResponsesResponse.body);
      if (galleryResponsesJsonResponse['success']) {
        setHidePreloader();
        var responsesList =
            galleryResponsesJsonResponse['data'].map<GalleryResponse>((elem) {
          return new GalleryResponse(
              id: elem['id'],
              student_id: elem['student_id'],
              firstName: elem['firstName'],
              lastName: elem['lastName'],
              picture: elem['picture'],
              response: elem['response']);
        }).toList();
        currentGallery[0].responsesList = responsesList;
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  setGalleryLike(id) async {
    setShowPreloader();
    var galleryLikesResponse =
        await http.get('$url/?query=AddGalleryLike&uuid=$uuid&gallery_id=$id');
    if (galleryLikesResponse.statusCode == 200) {
      var galleryLikesJsonResponse =
          convert.jsonDecode(galleryLikesResponse.body);
      if (galleryLikesJsonResponse['success']) {
        setHidePreloader();

        var currentGallery =
            galleries.data.where((element) => element.id == id).toList();
        currentGallery[0].canLike = false;
        currentGallery[0].likes += 1;
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }

  List getAvailbleClasses(index) {
    List classesToShow = [];

    galleries.data[index].classes.forEach((element) {
      List isClassAvaible =
          classesList.data.where((item) => item.value == element).toList();
      if (isClassAvaible != null && isClassAvaible.length > 0) {
        classesToShow.add(isClassAvaible[0].student_class_text);
      }
    });

    return classesToShow;
  }

  setGalleryResponse(id, response) async {
    setShowPreloader();

    var galleryResponseResponse = await http.get(
        '$url/?query=AddGalleryResponse&uuid=$uuid&gallery_id=$id&response=$response');
    if (galleryResponseResponse.statusCode == 200) {
      var galleryResponseJsonResponse =
          convert.jsonDecode(galleryResponseResponse.body);
      if (galleryResponseJsonResponse['success']) {
        var currentGallery =
            galleries.data.where((element) => element.id == id).toList();

        currentGallery[0].responses += 1;
        await getResponses(id);
        setHidePreloader();
        notifyListeners();
      } else {
        setHidePreloader();
        msg = 'NetworkError';
        showWebColoredToast();
      }
    } else {
      setHidePreloader();
      msg = 'NetworkError';
      showWebColoredToast();
    }
  }
}
