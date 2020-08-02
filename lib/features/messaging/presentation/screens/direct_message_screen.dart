import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/message_model.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ping_me/features/messaging/presentation/message_bloc/message_bloc.dart';

class DirectMessageScreen extends StatefulWidget {
  final User user;
  final String self;
  final CollectionReference chatRoomRef;
  DirectMessageScreen({this.user, this.chatRoomRef, this.self});

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  User get user => widget.user;
  CollectionReference get chatroomRef => widget.chatRoomRef;
  String get self => widget.self;
  final TextEditingController messageController = TextEditingController();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  final MessageBloc messageBloc = MessageBloc();
  _buildMessage(Message message, bool isMe) {
    final msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.white : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Bubble(
        nip: BubbleNip.rightBottom,
        nipHeight: 10,
        nipRadius: 1,
        nipWidth: 3,
        color: Colors.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.timestamp.toDate().toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
    if (isMe) {
      print(message.timestamp);
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: isMe ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: isMe ? Theme.of(context).primaryColor : Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              messageBloc.add(SendMessage(
                  chatroomRef: chatroomRef,
                  message: Message(
                      message: messageController.text,
                      sender: self,
                      receiver: user.uid,
                      timestamp: Timestamp.fromMillisecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch),
                      type: 1)));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(user.username),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<DashboardBloc>(context).add(GotoDashboard());
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: BlocProvider<MessageBloc>(
                      create: (BuildContext context) =>
                          messageBloc..add(FetchMessages(chatroomRef)),
                      child: BlocBuilder<MessageBloc, MessageState>(
                          builder: (BuildContext context, MessageState state) {
                        if (state is MessageInitial)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else if (state is FullChatHistory) {
                          return StreamBuilder(
                              initialData: state.initialChat,
                              stream: state.chats,
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                List<Message> chatList = [];
                                snap.data.documents.forEach((message) {
                                  chatList.add(Message.fromJson({
                                    'message': message['message'],
                                    'receiver': message['receiver'],
                                    'sender': message['sender'],
                                    'timestamp': message['timestamp'],
                                    'type': message['type']
                                  }));
                                });
                                chatList.sort((m1, m2) =>
                                    m1.timestamp.compareTo(m2.timestamp));
                                chatList = List.from(chatList.reversed);
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: chatList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMe =
                                        !(chatList[index].sender == user);
                                    return _buildMessage(chatList[index], isMe);
                                  },
                                );
                              });
                        }
                      }),
                    )),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
