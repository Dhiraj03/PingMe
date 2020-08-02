import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/message_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageState get initialState => MessageInitial();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is FetchMessages) {
      print('lmao');
      final chats = await firestoreRepository.fetchMessages(event.chatroomRef);
      yield FullChatHistory(chats: chats);
    } else if (event is SendMessage) {
      await firestoreRepository.sendMessage(event.chatroomRef, event.message);
      final chats = await firestoreRepository.fetchMessages(event.chatroomRef);
      yield FullChatHistory(chats: chats);
    }
  }
}
