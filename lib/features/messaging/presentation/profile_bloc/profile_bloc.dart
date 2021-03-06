import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileState get initialState => Initial();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  final UserRepository userRepository = UserRepository();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetInitialProfile) {
      final userId = await userRepository.getUser();
      final user = await firestoreRepository.fetchUser(userId);
      yield ProfileInitial(user: user);
    } else if (event is ChangeProfilePicture) {
      print(event.user.uid);
      await firestoreRepository.changeProfilePicture(
          event.link, event.user.uid);

      final modifiedUser = await firestoreRepository.fetchUser(event.user.uid);
      print('modified link' + modifiedUser.photoUrl.toString());
      yield ProfilePictureChanged(user: modifiedUser);
    }
  }
}
