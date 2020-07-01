import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_integ/models/user.dart';

class UserService {
  final db = Firestore.instance;

  static const USER_COLLECTION = "users";

  Future<User> findById(String id) async {
    try {
      DocumentSnapshot document =
          await db.collection(USER_COLLECTION).document(id).get();
      return User.fromJson(document);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> save(User user) async {
    try {
      await db.collection(USER_COLLECTION).add(user.toMap());
    } catch (error) {
      print(error);
    }
  }

  Future<void> update(User user) async {
    try {
      await db
          .collection(USER_COLLECTION)
          .document(user.id)
          .updateData(user.toMap());
    } catch (error) {
      print(error);
    }
  }
}
