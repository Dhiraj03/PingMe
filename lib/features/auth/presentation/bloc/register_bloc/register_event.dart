part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged({@required this.email});
  @override
  List get props => <dynamic>[email];

  @override
  String toString() => 'Email Changed : {email : $email}';
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged({@required this.password});
  @override
  String toString() => 'Password Changed : {password : $password}';
  @override
  List get props => <dynamic>[password];
}

class UsernameChanged extends RegisterEvent {
  final String username;
  UsernameChanged({@required this.username});
  @override
  String toString() => 'Username Changed : {username : $username}';
  @override
  List get props => <dynamic>[username];
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  Submitted(
      {@required this.email, @required this.password, @required this.username})
      : super();

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }

  @override
  List get props => <dynamic>[email, password, username];
}
