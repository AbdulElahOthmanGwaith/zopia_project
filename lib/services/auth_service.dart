import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email & password
  Future<UserModel?> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Check username availability
      final usernameDoc =
          await _db.collection('usernames').doc(username).get();
      if (usernameDoc.exists) throw Exception('اسم المستخدم محجوز بالفعل');

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: cred.user!.uid,
        name: name,
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );

      await _db.collection('users').doc(user.uid).set(user.toMap());
      await _db
          .collection('usernames')
          .doc(username)
          .set({'uid': user.uid});

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await getUser(cred.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // Update profile
  Future<void> updateProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Follow / Unfollow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    final currentRef = _db.collection('users').doc(currentUid);
    final targetRef = _db.collection('users').doc(targetUid);

    final currentDoc = await currentRef.get();
    final following = List<String>.from(currentDoc['following'] ?? []);

    if (following.contains(targetUid)) {
      await currentRef.update({
        'following': FieldValue.arrayRemove([targetUid])
      });
      await targetRef.update({
        'followers': FieldValue.arrayRemove([currentUid])
      });
    } else {
      await currentRef.update({
        'following': FieldValue.arrayUnion([targetUid])
      });
      await targetRef.update({
        'followers': FieldValue.arrayUnion([currentUid])
      });
    }
  }
}
