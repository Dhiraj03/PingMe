part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class Initial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  final User user;
  ProfileInitial({@required this.user});
  @override
  List<Object> get props => [user];
}

class ProfilePictureChanged extends ProfileState {
  final User user;
  ProfilePictureChanged({@required this.user});
  @override
  List get props => [user];
}
