part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetInitialProfile extends ProfileEvent {
  @override
  List get props => [];
}
