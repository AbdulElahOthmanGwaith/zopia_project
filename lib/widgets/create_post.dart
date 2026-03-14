import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../models/post_model.dart';

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();

  List<File> _selectedImages = [];
  List<String> _tags = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: mediaQuery.viewInsets.bottom),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // App bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const Spacer(),
                const Text(
                  'منشور جديد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('نشر'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: currentUser.photoUrl.isNotEmpty
                            ? NetworkImage(currentUser.photoUrl)
                            : null,
                        child: currentUser.photoUrl.isEmpty
                            ? Text(currentUser.name[0].toUpperCase())
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentUser.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.public, size: 12),
                                SizedBox(width: 4),
                                Text('عام', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content input
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'ماذا يدور في ذهنك؟',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),

                  // Selected images
                  if (_selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (_, i) => Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedImages[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => setState(() =>
                                    _selectedImages.removeAt(i)),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Tags
                  if (_tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _tags
                          .map((tag) => Chip(
                                label: Text('#$tag'),
                                onDeleted: () =>
                                    setState(() => _tags.remove(tag)),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: Color(0xFF6C5CE7)),
                  onPressed: _pickImages,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF00CEC9)),
                  onPressed: _takePhoto,
                ),
                IconButton(
                  icon: const Icon(Icons.tag, color: Color(0xFFFF6B9D)),
                  onPressed: _addTag,
                ),
                IconButton(
                  icon: const Icon(Icons.location_on_outlined, color: Color(0xFFFDCB6E)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final images = await _storageService.pickMultipleImages();
    if (images.isNotEmpty) {
      setState(() => _selectedImages.addAll(images));
    }
  }

  Future<void> _takePhoto() async {
    final image = await _storageService.pickImage(
        source: ImageSource.camera as dynamic);
    if (image != null) {
      setState(() => _selectedImages.add(image));
    }
  }

  void _addTag() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة هاشتاق'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            hintText: 'اكتب الهاشتاق',
            prefixText: '#',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final tag = _tagController.text.trim();
              if (tag.isNotEmpty) {
                setState(() => _tags.add(tag));
                _tagController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty &&
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب شيئاً أو أضف صورة')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user =
          context.read<AuthProvider>().currentUser!;
      List<String> mediaUrls = [];

      if (_selectedImages.isNotEmpty) {
        mediaUrls = await _storageService.uploadPostMedia(
            _selectedImages, user.uid);
      }

      final post = PostModel(
        id: '',
        userId: user.uid,
        username: user.username,
        userPhoto: user.photoUrl,
        content: _contentController.text.trim(),
        mediaUrls: mediaUrls,
        mediaType: _selectedImages.isNotEmpty ? 'image' : 'text',
        tags: _tags,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createPost(post);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// ignore: avoid_classes_with_only_static_members
class ImageSource {
  static const camera = 'camera';
  static const gallery = 'gallery';
}
