import 'dart:io';

class Album {
  Album({
    required this.coverImage,
    required this.title,
    this.description,
    this.location,
  });

  File coverImage;
  String title;
  String? description;
  String? location;
}