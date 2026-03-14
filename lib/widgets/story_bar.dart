import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';

class StoryBar extends StatelessWidget {
  final UserModel? currentUser;

  const StoryBar({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    // Demo stories — replace with real Firestore stream
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 8,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _MyStoryItem(user: currentUser);
          }
          return _StoryItem(index: index);
        },
      ),
    );
  }
}

class _MyStoryItem extends StatelessWidget {
  final UserModel? user;

  const _MyStoryItem({this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.grey.shade300, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: user?.photoUrl.isNotEmpty == true
                        ? CachedNetworkImageProvider(user!.photoUrl)
                        : null,
                    child: user?.photoUrl.isEmpty != false
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C5CE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'قصتي',
              style: TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final int index;

  const _StoryItem({required this.index});

  static const List<String> _names = [
    'أحمد', 'فاطمة', 'محمد', 'نورة', 'عمر', 'ليلى', 'خالد'
  ];

  static const List<Color> _colors = [
    Color(0xFF6C5CE7),
    Color(0xFFFF6B9D),
    Color(0xFF00CEC9),
    Color(0xFFFDCB6E),
    Color(0xFF55EFC4),
    Color(0xFFE17055),
    Color(0xFF74B9FF),
  ];

  @override
  Widget build(BuildContext context) {
    final name = _names[(index - 1) % _names.length];
    final color = _colors[(index - 1) % _colors.length];

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: color.withOpacity(0.2),
                  child: Text(
                    name[0],
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
