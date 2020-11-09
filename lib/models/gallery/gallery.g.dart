// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GelleriesList _$GelleriesListFromJson(Map<String, dynamic> json) {
  return GelleriesList(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Gallery.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$GelleriesListToJson(GelleriesList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'data': instance.data,
    };

Gallery _$GalleryFromJson(Map<String, dynamic> json) {
  return Gallery(
    id: json['id'] as int,
    likes: json['likes'] as int,
    name: json['name'] as String,
    responses: json['responses'] as int,
    image: json['image'] == null
        ? null
        : GalleryImage.fromJson(json['image'] as Map<String, dynamic>),
    classes: _splitClasses(json['classes']),
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    date: json['date'],
    is_published: json['is_published'] as bool,
    is_primary: json['is_primary'] as bool,
  )
    ..student_id = _fromJsonId(json['student_id'])
    ..canLike = json['canLike'] as bool
    ..imagesList = (json['imagesList'] as List)
        ?.map((e) =>
            e == null ? null : GalleryImage.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..responsesList = (json['responsesList'] as List)
        ?.map((e) => e == null
            ? null
            : GalleryResponse.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..likesList = (json['likesList'] as List)
        ?.map((e) =>
            e == null ? null : GalleryLikes.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'likes': instance.likes,
      'responses': instance.responses,
      'student_id': instance.student_id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'classes': instance.classes,
      'canLike': instance.canLike,
      'date': instance.date,
      'is_published': instance.is_published,
      'is_primary': instance.is_primary,
      'image': instance.image,
      'imagesList': instance.imagesList,
      'responsesList': instance.responsesList,
      'likesList': instance.likesList,
    };

GalleryLikes _$GalleryLikesFromJson(Map<String, dynamic> json) {
  return GalleryLikes(
    id: json['id'] as int,
    student_id: json['student_id'] as int,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
  );
}

Map<String, dynamic> _$GalleryLikesToJson(GalleryLikes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.student_id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

GalleryResponse _$GalleryResponseFromJson(Map<String, dynamic> json) {
  return GalleryResponse(
    id: json['id'] as int,
    student_id: json['student_id'] as int,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    response: json['response'] as String,
    picture: json['picture'] as String,
  );
}

Map<String, dynamic> _$GalleryResponseToJson(GalleryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.student_id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'response': instance.response,
      'picture': instance.picture,
    };

GalleryImage _$GalleryImageFromJson(Map<String, dynamic> json) {
  return GalleryImage(
    id: json['id'] as int,
    name: json['name'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$GalleryImageToJson(GalleryImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };

ClassesList _$ClassesListFromJson(Map<String, dynamic> json) {
  return ClassesList(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Classes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ClassesListToJson(ClassesList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Classes _$ClassesFromJson(Map<String, dynamic> json) {
  return Classes(
    student_class: json['student_class'] as String,
    student_class_num: json['student_class_num'] as int,
    student_class_text: json['student_class_text'] as String,
    value: _fromJsonId(json['value']),
  )..selected = json['selected'] as bool ?? false;
}

Map<String, dynamic> _$ClassesToJson(Classes instance) => <String, dynamic>{
      'student_class': instance.student_class,
      'student_class_num': instance.student_class_num,
      'value': instance.value,
      'student_class_text': instance.student_class_text,
      'selected': instance.selected,
    };
