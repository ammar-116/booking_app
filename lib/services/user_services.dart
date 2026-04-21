import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, String email, String role) async {
    final doc = await _db.collection("users").doc(uid).get();

    if (!doc.exists) {
      await _db.collection("users").doc(uid).set({
        "email": email,
        "role": role,
      });
    }
  }

  Future<String> getRole(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc['role'];
  }
}