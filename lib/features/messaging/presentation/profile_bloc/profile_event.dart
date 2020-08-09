part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetInitialProfile extends ProfileEvent {
  @override
  List get props => [];
}

class ChangeProfilePicture extends ProfileEvent {
  final User user;
  final String link;
  ChangeProfilePicture({@required this.user, @required this.link});
  @override
  List get props => [user];
}
