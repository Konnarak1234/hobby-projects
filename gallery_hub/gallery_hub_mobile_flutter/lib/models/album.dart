import 'dart:io';

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
  String? updated;
  
}