import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  final UserRepository userRepository = UserRepository();

  DashboardState get initialState => DashboardInitial();
  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is GetInitialChats) {
      print('lol');
      String uid = await userRepository.getUser();
      final initialData = await firestoreRepository.getInitialChats(uid);
      final stream = firestoreRepository.fetchRecentChats(uid);    
      yield ClassicDashboard(initialData: initialData, recentChats: stream, self : uid);
    } else if (event is GotoDashboard) {
      String uid = await userRepository.getUser();
      final initialData = await firestoreRepository.getInitialChats(uid);
      final stream = firestoreRepository.fetchRecentChats(uid);
      yield ClassicDashboard(initialData: initialData, recentChats: stream, self: uid);
    } else if (event is OpenDM) {
      final uid1 = await userRepository.getUser();
      final uid2 = event.uid2;
      final user2 = await firestoreRepository.fetchUser(uid2);
      final chatRoomRef =
          await firestoreRepository.getChatroomReference(uid1, uid2);
      print(chatRoomRef.id);
      yield DirectMessages(chatRoomRef: chatRoomRef, user2: user2, self: uid1);
    } else if (event is Searching) {
      final List<User> searchlist =
          await firestoreRepository.searchForUsers(event.searchTerm);
      print(searchlist.length);
      yield Search(searchList: searchlist);
    }
  }
}
