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
  final QuerySnapshot initialChat;
  FullChatHistory({@required this.chats, @required this.initialChat});
  @override
  List get props => [chats];
}
