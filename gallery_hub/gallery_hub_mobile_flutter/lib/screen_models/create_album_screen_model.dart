import 'dart:io';
import 'package:gallery_hub_mobile_flutter/models/album.dart';
import 'package:gallery_hub_mobile_flutter/services/album_service.dart';

class CreateAlbumScreenModel {
  CreateAlbumScreenModel();
  

  File? coverImage;
  String? title;
  String? description;
  String? location;

  final albumService = AlbumService();

  Future<void> createAlbum() async {
    final album = Album(
      coverImage: coverImage!,
      title: title!,
      description: description,
      location: location,
    );

    if(!await albumService.uploadAlbum(album)) {
      throw Exception(albumService.error);
    }
  }
}
