import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/messaging/data/message_model.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';

class FirestoreRepository {
  final UserRepository userRepository = UserRepository();
  static final firestoreInstance = Firestore.instance;
  void createUser(String email, String username) async {
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

  Future<CollectionReference> getChatroomReference(
      String uid1, String uid2) async {
    final chats = firestoreInstance.collection('chats');
    final QuerySnapshot snapshot1 = await chats
        .where('uid1', isEqualTo: uid1)
        .where('uid2', isEqualTo: uid2)
        .getDocuments();
    if (snapshot1.documents.length == 1) {
      final docId = snapshot1.documents[0].documentID;
      return chats.document(docId).collection('chat_history');
    }
    final QuerySnapshot snapshot2 = await chats
        .where('uid1', isEqualTo: uid2)
        .where('uid2', isEqualTo: uid1)
        .getDocuments();
    if (snapshot2.documents.length == 1) {
      final docId = snapshot2.documents[0].documentID;
      return chats
          .document(docId)
          .collection('chat_history');
    }

    final res = await chats.add({'uid1': uid1, 'uid2': uid2});
    return res.collection('chat_history');
  }

  Future<List<User>> searchForUsers(String searchTerm) async {
    final users = firestoreInstance.collection('users');
    final List<User> searchList = [];
    final searchListDocs =
        await users.where('username', isEqualTo: searchTerm).getDocuments();
    searchListDocs.documents.forEach((doc) {
      searchList.add(User(
          email: doc['email'], username: doc['username'], uid: doc['uid']));
    });
    return searchList;
  }

  Future<User> fetchUser(String uid) async {
    final users = firestoreInstance.collection('users');
    final ref = await users.where('uid', isEqualTo: uid).getDocuments();
    final doc = ref.documents[0];
    return User(
        username: doc['username'], email: doc['email'], uid: doc['uid']);
  }

  Stream<QuerySnapshot> fetchMessages(CollectionReference chatroomRef) {
    print(chatroomRef.id);
    return chatroomRef.snapshots();
  }

  Future<QuerySnapshot> getInitialData(CollectionReference chatroomref) async {
    return await chatroomref.getDocuments();
  }

  Future<void> sendMessage(
      CollectionReference chatroomref, Message message) async {
    chatroomref.add({
      'message': message.message,
      'sender': message.sender,
      'receiver': message.receiver,
      'timestamp': DateTime.now(),
      'type': message.type,
      'photourl': message.photoUrl
    });
  }
}
