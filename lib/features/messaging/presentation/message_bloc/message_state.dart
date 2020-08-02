part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class FullChatHistory extends MessageState {
  final Stream<QuerySnapshot> chats;
  FullChatHistory({@required this.chats});
  @override
  List get props => [chats];
}
