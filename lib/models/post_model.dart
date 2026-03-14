class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userPhoto;
  final String content;
  final List<String> mediaUrls;
  final String mediaType; // 'image', 'video', 'text'
  final List<String> likes;
  final int commentsCount;
  final int sharesCount;
  final List<String> tags;
  final DateTime createdAt;
  bool isLiked;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userPhoto,
    required this.content,
    this.mediaUrls = const [],
    this.mediaType = 'text',
    this.likes = const [],
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.tags = const [],
    required this.createdAt,
    this.isLiked = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userPhoto: map['userPhoto'] ?? '',
      content: map['content'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      mediaType: map['mediaType'] ?? 'text',
      likes: List<String>.from(map['likes'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
      sharesCount: map['sharesCount'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'username': username,
        'userPhoto': userPhoto,
        'content': content,
        'mediaUrls': mediaUrls,
        'mediaType': mediaType,
        'likes': likes,
        'commentsCount': commentsCount,
        'sharesCount': sharesCount,
        'tags': tags,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}
