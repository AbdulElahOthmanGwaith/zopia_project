import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../models/ad_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // ─── POSTS ───────────────────────────────────────────────────
  Stream<List<PostModel>> getFeedPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => PostModel.fromMap(d.data())).toList());
  }

  Stream<List<PostModel>> getUserPosts(String userId) {
    return _db
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => PostModel.fromMap(d.data())).toList());
  }

  Future<void> createPost(PostModel post) async {
    final id = _uuid.v4();
    final newPost = PostModel(
      id: id,
      userId: post.userId,
      username: post.username,
      userPhoto: post.userPhoto,
      content: post.content,
      mediaUrls: post.mediaUrls,
      mediaType: post.mediaType,
      tags: post.tags,
      createdAt: DateTime.now(),
    );
    await _db.collection('posts').doc(id).set(newPost.toMap());
  }

  Future<void> toggleLike(String postId, String userId) async {
    final ref = _db.collection('posts').doc(postId);
    final doc = await ref.get();
    final likes = List<String>.from(doc['likes'] ?? []);

    if (likes.contains(userId)) {
      await ref.update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      await ref.update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  // ─── ADS ─────────────────────────────────────────────────────
  Stream<List<AdModel>> getAds({String? category}) {
    Query query = _db
        .collection('ads')
        .where('isSold', isEqualTo: false)
        .orderBy('isFeatured', descending: true)
        .orderBy('createdAt', descending: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map(
        (snap) => snap.docs.map((d) => AdModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> createAd(AdModel ad) async {
    final id = _uuid.v4();
    final newAd = AdModel(
      id: id,
      sellerId: ad.sellerId,
      sellerName: ad.sellerName,
      sellerPhoto: ad.sellerPhoto,
      title: ad.title,
      description: ad.description,
      price: ad.price,
      currency: ad.currency,
      imageUrls: ad.imageUrls,
      category: ad.category,
      condition: ad.condition,
      location: ad.location,
      createdAt: DateTime.now(),
    );
    await _db.collection('ads').doc(id).set(newAd.toMap());
  }

  Future<void> markAdAsSold(String adId) async {
    await _db.collection('ads').doc(adId).update({'isSold': true});
  }

  // ─── NOTIFICATIONS ────────────────────────────────────────────
  Stream<List<NotificationModel>> getNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => NotificationModel.fromMap(d.data()))
            .toList());
  }

  Future<void> sendNotification(NotificationModel notif) async {
    final id = _uuid.v4();
    await _db.collection('notifications').doc(id).set({
      ...notif.toMap(),
      'id': id,
    });
  }

  Future<void> markNotificationRead(String notifId) async {
    await _db
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  Future<void> markAllNotificationsRead(String userId) async {
    final batch = _db.batch();
    final snap = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
