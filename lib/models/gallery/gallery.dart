import 'package:json_annotation/json_annotation.dart';

part 'gallery.g.dart';

@JsonSerializable()
class GelleriesList {
  int totalCount;
  List<Gallery> data;

  GelleriesList({this.data, this.totalCount});

  factory GelleriesList.fromJson(Map<String, dynamic> data) =>
      _$GelleriesListFromJson(data);
}

@JsonSerializable()
class Gallery {
  int id;
  String name;
  int likes;
  int responses;
  @JsonKey(fromJson: _fromJsonId)
  String student_id;
  String firstName;
  String lastName;
  @JsonKey(fromJson: _splitClasses)
  List classes;
  bool canLike;
  var date;
  bool is_published;
  bool is_primary;
  GalleryImage image;
  @JsonKey(nullable: true)
  List<GalleryImage> imagesList;
  @JsonKey(nullable: true)
  List<GalleryResponse> responsesList;
  @JsonKey(nullable: true)
  List<GalleryLikes> likesList;

  Gallery(
      {this.id,
      this.likes,
      this.name,
      this.responses,
      this.image,
      this.classes,
      this.firstName,
      this.lastName,
      this.date,
      this.is_published,
      this.is_primary});

  factory Gallery.fromJson(Map<String, dynamic> data) =>
      _$GalleryFromJson(data);
}

@JsonSerializable()
class GalleryLikes {
  int id;
  int student_id;
  String firstName;
  String lastName;

  GalleryLikes({
    this.id,
    this.student_id,
    this.firstName,
    this.lastName,
  });

  factory GalleryLikes.fromJson(Map<String, dynamic> data) =>
      _$GalleryLikesFromJson(data);
}

@JsonSerializable()
class GalleryResponse {
  int id;
  int student_id;
  String firstName;
  String lastName;
  String response;
  String picture;
  GalleryResponse(
      {this.id,
      this.student_id,
      this.firstName,
      this.lastName,
      this.response,
      this.picture});

  factory GalleryResponse.fromJson(Map<String, dynamic> data) =>
      _$GalleryResponseFromJson(data);
}

@JsonSerializable()
class GalleryImage {
  int id;
  String name;
  String url;
  GalleryImage({this.id, this.name, this.url});

  factory GalleryImage.fromJson(Map<String, dynamic> data) =>
      _$GalleryImageFromJson(data);
}

@JsonSerializable()
class ClassesList {
  List<Classes> data;

  ClassesList({this.data});

  factory ClassesList.fromJson(Map<String, dynamic> data) =>
      _$ClassesListFromJson(data);
}

@JsonSerializable()
class Classes {
  String student_class;
  int student_class_num;
  @JsonKey(fromJson: _fromJsonId)
  String value;
  String student_class_text;
  @JsonKey(defaultValue: false)
  bool selected;

  Classes(
      {this.student_class,
      this.student_class_num,
      this.student_class_text,
      this.value});

  factory Classes.fromJson(Map<String, dynamic> data) =>
      _$ClassesFromJson(data);
}

String _fromJsonId(id) {
  return id.toString();
}

_splitClasses(value) {
  if (value == "") {
    return [];
  } else {
    return value.split(",");
  }
}
