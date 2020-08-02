part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class FetchMessages extends MessageEvent {
  final CollectionReference chatroomRef;
  FetchMessages(@required this.chatroomRef);
  @override
  List get props => [chatroomRef];
}

class SendMessage extends MessageEvent {
  final CollectionReference chatroomRef;
  final Message message;
  SendMessage({@required this.chatroomRef, @required this.message});
  @override
  List get props => [chatroomRef, message];
}
