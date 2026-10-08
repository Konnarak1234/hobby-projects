import 'dart:io';

import 'package:gallery_hub_mobile_flutter/utils/constants.dart';

class Album {
  Album({
    this.coverImage,
    this.title,
    this.description,
    this.location,
    this.uuid,
    this.image,
    this.photoCount,
    this.updated,
  });

  File? coverImage;
  String? title;
  String? description;
  String? location;


  String? uuid;
  String? image;
  int? photoCount;
  DateTime? updated;

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      updated: DateTime.parse(
        json['updated'] as String,
      ),
      photoCount: json['photoCount'] as int,
      image:
          '${AppConstants.baseUrl}'
          'albums/${json['uuid']}/cover',
    );
  }
  
}