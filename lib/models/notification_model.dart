class NotificationModel {
  final String id;
  final String userId;
  final String fromUserId;
  final String fromUserName;
  final String fromUserPhoto;
  final String type; // 'like', 'comment', 'follow', 'message', 'ad_reply'
  final String message;
  final String? targetId; // postId, adId, etc.
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserPhoto,
    required this.type,
    required this.message,
    this.targetId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      fromUserName: map['fromUserName'] ?? '',
      fromUserPhoto: map['fromUserPhoto'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      targetId: map['targetId'],
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromUserPhoto': fromUserPhoto,
        'type': type,
        'message': message,
        'targetId': targetId,
        'isRead': isRead,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  String get icon {
    switch (type) {
      case 'like':
        return '❤️';
      case 'comment':
        return '💬';
      case 'follow':
        return '👤';
      case 'message':
        return '✉️';
      case 'ad_reply':
        return '🏷️';
      default:
        return '🔔';
    }
  }
}
