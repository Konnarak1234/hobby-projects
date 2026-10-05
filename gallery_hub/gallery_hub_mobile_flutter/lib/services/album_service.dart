import 'package:gallery_hub_mobile_flutter/models/album.dart';
import 'package:gallery_hub_mobile_flutter/services/api_service.dart';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';

class AlbumService {
  final apiService = ApiService();
  String? error;

  Future<bool> uploadAlbum(Album album) async {
    Map<String, String> data = {
      'title': album.title,
      'description': album.description ?? '',
      'location': album.location ?? '',
    };

    final localStorageService = LocalStorageService();
    String token = (await localStorageService.getToken())!;

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await apiService.multipartPost(
        'albums',
        fields: data,
        headers: header,
        fileField: 'cover_image',
        filePath: album.coverImage.path,
      );

      if(response.statusCode == 200) {
        return true;
      }

      if(response.statusCode == 401) {
        error = 'Unauthorize';
      } 

      if(response.statusCode == 422) {
        error = 'Invalid input';
      }

      return false;

    } catch (e) {
      error = e.toString();
      return false;
    }
  }
}
