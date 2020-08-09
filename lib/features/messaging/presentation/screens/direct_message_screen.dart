import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/message_model.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ping_me/features/messaging/presentation/message_bloc/message_bloc.dart';
import 'package:ping_me/features/messaging/presentation/services/date_formatting.dart';

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

  final picker = ImagePicker();
  Future<File> getImage() async {
    print('inside the function');
    var tempImage = await picker
        .getImage(source: ImageSource.gallery)
        .catchError((e) => print(e.toString()));
    return File(tempImage.path);
  }

  Future<String> uploadImage(
      File pickedImage, String userID, String timestamp) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('chats/${userID}${timestamp}.jpg');
    StorageTaskSnapshot snapshot =
        await firebaseStorageRef.putFile(pickedImage).onComplete;
    String link;
    if (snapshot.error == null) {
      link = await snapshot.ref.getDownloadURL();
    }
    return link;
  }

  _buildMessage(Message message, bool isMe) {
    final BubbleNip nipDirection =
        isMe ? BubbleNip.rightBottom : BubbleNip.leftBottom;
    final Color messageColor =
        isMe ? Colors.teal[400] : Color.fromRGBO(255, 255, 255, 0.15);
    final msg = message.type == 1
        ? Container(
            margin: isMe
                ? EdgeInsets.only(
                    bottom: 8.0,
                    left: 80.0,
                  )
                : EdgeInsets.only(
                    right: 30.0,
                    bottom: 8.0,
                  ),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Bubble(
              nip: nipDirection,
              nipHeight: 10,
              nipRadius: 1,
              nipWidth: 3,
              color: messageColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    formatDate(message.timestamp.toDate()),
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
          )
        : Container(
         
            margin: isMe
                ? EdgeInsets.only(
                    bottom: 8.0,
                    left: 80.0,
                  )
                : EdgeInsets.only(
                    right: 30.0,
                    bottom: 8.0,
                  ),
            height:  (MediaQuery.of(context).size.width * 0.35) / MediaQuery.of(context).size.aspectRatio,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.teal[400],
                width: 3
              ),
              image: DecorationImage(
                image: NetworkImage(message.photoUrl),
                fit: BoxFit.fill
                )
            ),
            
          );

    if (isMe) {
      print(message.timestamp);
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer(String uid) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 55.0,
      color: Color.fromRGBO(255, 255, 255, 0.2),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Colors.teal[400],
            onPressed: () async {
              final pickedImage = await getImage();
              final link = await uploadImage(
                  pickedImage, self, DateTime.now().toString());
              messageBloc.add(SendMessage(
                  chatroomRef: chatroomRef,
                  message: Message(
                      message: 'Image',
                      photoUrl: link,
                      sender: self,
                      receiver: user.uid,
                      timestamp: Timestamp.fromMillisecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch),
                      type: 2)));
            },
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
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
            color: Colors.teal[400],
            onPressed: () {
              messageBloc.add(SendMessage(
                  chatroomRef: chatroomRef,
                  message: Message(
                      message: messageController.text,
                      photoUrl: null,
                      sender: self,
                      receiver: user.uid,
                      timestamp: Timestamp.fromMillisecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch),
                      type: 1)));
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> willPopCallBack(BuildContext mainContext) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit to the dashboard?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(mainContext).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.teal[400]),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<DashboardBloc>(mainContext)
                      .add(GotoDashboard());
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.teal[400]),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopCallBack(context),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(12, 12, 12, 1),
        appBar: AppBar(
          elevation: 0,
          title: Row(children: <Widget>[
            user.photoUrl != null
                ? Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user.photoUrl))),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            SizedBox(width: 10),
            Text(user.username)
          ]),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.09),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: BlocProvider<MessageBloc>(
                          create: (BuildContext context) =>
                              messageBloc..add(FetchMessages(chatroomRef)),
                          child: BlocBuilder<MessageBloc, MessageState>(builder:
                              (BuildContext context, MessageState state) {
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
                                      print(message['photoUrl']);
                                      chatList.add(Message.fromJson({
                                        'message': message['message'],
                                        'receiver': message['receiver'],
                                        'sender': message['sender'],
                                        'timestamp': message['timestamp'],
                                        'type': message['type'],
                                        'photoUrl': message['photoUrl']
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
                                        print('link is here' +
                                            chatList[index].photoUrl.toString());
                                        final bool isMe =
                                            (chatList[index].receiver == user.uid);

                                        return _buildMessage(
                                            chatList[index], isMe);
                                      },
                                    );
                                  });
                            }
                          }),
                        )),
                ),
                ),
              
              _buildMessageComposer(self),
            ],
          ),
        ),
      ),
    );
  }
}
