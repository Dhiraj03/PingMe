import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String photoUrl;
  final String uid;
  final String email;

  User({this.email, this.photoUrl, this.uid, this.username});

  @override
  List get props => [username, photoUrl, uid, email];
}
