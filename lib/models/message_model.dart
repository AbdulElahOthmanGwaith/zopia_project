class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderPhoto;
  final String content;
  final String type; // 'text', 'image', 'voice'
  final String? mediaUrl;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderPhoto,
    required this.content,
    this.type = 'text',
    this.mediaUrl,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhoto: map['senderPhoto'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? 'text',
      mediaUrl: map['mediaUrl'],
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'senderName': senderName,
        'senderPhoto': senderPhoto,
        'content': content,
        'type': type,
        'mediaUrl': mediaUrl,
        'isRead': isRead,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

class ChatModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String> participantPhotos;
  final String lastMessage;
  final String lastSenderId;
  final int unreadCount;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.participantPhotos,
    this.lastMessage = '',
    this.lastSenderId = '',
    this.unreadCount = 0,
    required this.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
      participantPhotos:
          Map<String, String>.from(map['participantPhotos'] ?? {}),
      lastMessage: map['lastMessage'] ?? '',
      lastSenderId: map['lastSenderId'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'participants': participants,
        'participantNames': participantNames,
        'participantPhotos': participantPhotos,
        'lastMessage': lastMessage,
        'lastSenderId': lastSenderId,
        'unreadCount': unreadCount,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };
}
