class UserModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String photoUrl;
  final String bio;
  final String location;
  final List<String> followers;
  final List<String> following;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    this.photoUrl = '',
    this.bio = '',
    this.location = '',
    this.followers = const [],
    this.following = const [],
    this.isVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      isVerified: map['isVerified'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'location': location,
        'followers': followers,
        'following': following,
        'isVerified': isVerified,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? bio,
    String? location,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      username: username,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      followers: followers,
      following: following,
      isVerified: isVerified,
      createdAt: createdAt,
    );
  }
}
