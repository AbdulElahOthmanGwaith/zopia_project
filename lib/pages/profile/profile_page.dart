import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final String? userId; // null = current user
  const ProfilePage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser!;
    final isMyProfile = userId == null || userId == currentUser.uid;

    return Scaffold(
      body: StreamBuilder<List<PostModel>>(
        stream: FirestoreService().getUserPosts(userId ?? currentUser.uid),
        builder: (context, snapshot) {
          final posts = snapshot.data ?? [];
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, currentUser, isMyProfile),
              SliverToBoxAdapter(
                child: _buildProfileInfo(context, currentUser, posts.length, isMyProfile),
              ),
              if (posts.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_off_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('لا توجد منشورات بعد',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPostTile(posts[index]),
                    childCount: posts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, UserModel user, bool isMyProfile) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFFF6B9D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        if (isMyProfile)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettings(context),
          ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, UserModel user,
      int postsCount, bool isMyProfile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? CachedNetworkImageProvider(user.photoUrl)
                        : null,
                    child: user.photoUrl.isEmpty
                        ? Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 36),
                          )
                        : null,
                  ),
                ),
              ),
              const Spacer(),
              if (isMyProfile)
                OutlinedButton(
                  onPressed: () => _showEditProfile(context, user),
                  child: const Text('تعديل الملف'),
                )
              else
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('متابعة'),
                ),
            ],
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (user.isVerified) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: Color(0xFF6C5CE7), size: 20),
              ],
            ],
          ),
          Text('@${user.username}',
              style: TextStyle(color: Colors.grey.shade600)),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(user.bio),
          ],
          if (user.location.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(user.location,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'منشور', count: postsCount),
              _StatItem(
                  label: 'متابع', count: user.followers.length),
              _StatItem(
                  label: 'يتابع', count: user.following.length),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPostTile(PostModel post) {
    return Container(
      color: Colors.grey.shade200,
      child: post.mediaUrls.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: post.mediaUrls.first,
              fit: BoxFit.cover,
            )
          : Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Text(
                  post.content.length > 50
                      ? '${post.content.substring(0, 50)}...'
                      : post.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _SettingsSheet(),
    );
  }

  void _showEditProfile(BuildContext context, UserModel user) {
    // Navigate to edit profile
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label,
            style:
                const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final authProvider = context.read<AuthProvider>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('الإعدادات',
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('الوضع الليلي'),
            trailing: Switch(
              value: themeProvider.isDark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            trailing: Text(langProvider.isArabic ? 'العربية' : 'English'),
            onTap: () => langProvider.toggleLanguage(),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
