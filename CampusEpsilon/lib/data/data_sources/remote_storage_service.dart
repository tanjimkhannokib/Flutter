import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:campusepsilon/common/env_variables.dart';

abstract class RemoteStorageService {
  Future<String> uploadImage(File imageFile, {String? folderName});
}

class RemoteStorageServiceImpl implements RemoteStorageService {
  @override
  Future<String> uploadImage(File imageFile, {String? folderName}) async {
    try {
      final cloudinary =
          CloudinaryPublic('dgsymucne', 'campusepsilon');

      CloudinaryResponse response = await cloudinary
          .uploadFile(
            CloudinaryFile.fromFile(imageFile.path, folder: folderName),
          )
          .timeout(const Duration(seconds: 5));

      return response.secureUrl;
    } catch (e) {
      rethrow;
    }
  }
}
