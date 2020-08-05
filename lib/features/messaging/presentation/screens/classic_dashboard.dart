import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';

class ClassicDashboardScreen extends StatefulWidget {
  final Stream<QuerySnapshot> recentChats;
  final QuerySnapshot initialData;
  final String self;
  ClassicDashboardScreen(
      {@required this.recentChats,
      @required this.initialData,
      @required this.self});
  @override
  _ClassicDashboardScreenState createState() => _ClassicDashboardScreenState();
}

class _ClassicDashboardScreenState extends State<ClassicDashboardScreen> {
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  Stream<QuerySnapshot> get recentChats => widget.recentChats;
  QuerySnapshot get initialData => widget.initialData;
  String get self => widget.self;
  Widget buildRecentChatTile(String username, String lastText) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.purple,
        child: Text(username[0].toUpperCase(),
            style: TextStyle(color: Colors.white)),
      ),
      title: Text(username),
      subtitle: Text(lastText),
    );
  }

  Future<bool> willPopCallBack() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the application?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.purple),
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
      onWillPop: willPopCallBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: Icon(Icons.arrow_back),
          title: Text('Ping Me'),
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            backgroundColor: Colors.purple,
            onPressed: () {
              BlocProvider.of<DashboardBloc>(context)
                  .add(Searching(searchTerm: ''));
            }),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                        initialData: initialData,
                        stream: recentChats,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                String otherUser;
                                if (snapshot.data.documents[index]['uid1'] ==
                                    self)
                                  otherUser =
                                      snapshot.data.documents[index]['uid2'];
                                else
                                  otherUser =
                                      snapshot.data.documents[index]['uid1'];
                                return FutureBuilder(
                                    future: firestoreRepository
                                        .fetchUser(otherUser),
                                    builder: (BuildContext context,
                                        AsyncSnapshot user) {
                                      if (user.connectionState ==
                                              ConnectionState.none ||
                                          user.connectionState ==
                                              ConnectionState.waiting ||
                                          user.hasError)
                                        return Container();
                                      else
                                        return GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<DashboardBloc>(
                                                    context)
                                                .add(OpenDM(
                                                    uid2: user.data.uid));
                                          },
                                          child: buildRecentChatTile(
                                              user.data.username,
                                              snapshot.data.documents[index]
                                                  ['last_message']),
                                        );
                                    });
                              });
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
