import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';

class FirestoreRepository {
  final UserRepository userRepository = UserRepository();
  static final firestoreInstance = Firestore.instance;
  void createUser(String email, String username) async{
    print('creating a user');
    final users = firestoreInstance.collection('users');
    final uid = await userRepository.getUser();
    users.add({'uid': uid, 'email': email, 'username': username});
  }

  Future<bool> validUsername(String username) async {
    final users = firestoreInstance.collection('users');
    final QuerySnapshot snapshot =
        await users.where('username', isEqualTo: username).getDocuments();
    if (snapshot.documents.length == 0) return true;
    return false;
  }
}
