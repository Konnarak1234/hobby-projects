import 'package:gallery_hub_mobile_flutter/models/album.dart';
import 'package:gallery_hub_mobile_flutter/services/album_service.dart';

class ViewAlbumScreenModel {

  ViewAlbumScreenModel({required this.onSetState});

  bool isLoading = false;
  final albumService = AlbumService();
  final void Function() onSetState;
  List<Album> albums = [];

  void getAlbums() async {
    if(await albumService.getAlbums()) {
      
    } else {

    }

    albums = albumService.albums;
    
    isLoading = false;
    onSetState();
  }
}