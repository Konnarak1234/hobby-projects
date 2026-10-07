import 'dart:convert';

import 'package:gallery_hub_mobile_flutter/models/album.dart';
import 'package:gallery_hub_mobile_flutter/services/api_service.dart';
import 'package:gallery_hub_mobile_flutter/services/local_storage_service.dart';
import 'package:gallery_hub_mobile_flutter/utils/constants.dart';

class AlbumService {
  final apiService = ApiService();
  final localStorageService = LocalStorageService();
  String? error;
  List<Album> albums = [];

  Future<bool> getAlbums() async {
    try {
      // could cause an exception
      final response = await apiService.get('albums');

      final bodyData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        albums =
            bodyData['albums'].Map(
                  (a) => Album(
                    title: a.title,
                    uuid: a.uuid,
                    description: a.description,
                    location: a.location,
                    updated: a.lastUpdated,
                    photoCount: a.photoCount,
                    image: '${AppConstants.baseUrl}${a.uuid}/albums',
                  ),
                )
                as List<Album>;
        return true;
      }

      if (response.statusCode == 401) {
        error = bodyData['message'];
      }
      print('error: $error');

      return false;

    } catch (e) {
      print('error: ${e.toString()}');
      error = e.toString();
      return false;
    }
  }

  Future<bool> uploadAlbum(Album album) async {
    Map<String, String> data = {
      'title': album.title!,
      'description': album.description ?? '',
      'location': album.location ?? '',
    };

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
        filePath: album.coverImage!.path,
      );

      final bodyData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(bodyData['album']);
        return true;
      }

      if (response.statusCode == 401) {
        error = bodyData['message'];
      } else if (response.statusCode == 422) {
        error = bodyData['message'];
      } else {
        error = bodyData['message'];
      }

      return false;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }
}
