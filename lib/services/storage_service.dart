import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  // Pick image from gallery
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1080,
    );
    return picked.map((x) => File(x.path)).toList();
  }

  // Upload profile photo
  Future<String> uploadProfilePhoto(File file, String uid) async {
    final ref = _storage.ref('profiles/$uid/avatar.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  // Upload post media
  Future<List<String>> uploadPostMedia(List<File> files, String userId) async {
    final urls = <String>[];
    for (final file in files) {
      final id = _uuid.v4();
      final ext = file.path.split('.').last;
      final ref = _storage.ref('posts/$userId/$id.$ext');
      await ref.putFile(file);
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  // Upload ad images
  Future<List<String>> uploadAdImages(List<File> files, String userId) async {
    final urls = <String>[];
    for (final file in files) {
      final id = _uuid.v4();
      final ref = _storage.ref('ads/$userId/$id.jpg');
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  // Delete file by URL
  Future<void> deleteFileByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }
}
