import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/messaging/presentation/profile_bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();
  Future<File> getImage() async {
    print('inside the function');
    var tempImage = await picker
        .getImage(source: ImageSource.gallery)
        .catchError((e) => print(e.toString()));
    return File(tempImage.path);
  }

  Future<String> uploadImage(File pickedImage) async {
    var randomNumber = Random(25);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${randomNumber.nextInt(5000).toString()}.jpg');
    StorageTaskSnapshot snapshot =
        await firebaseStorageRef.putFile(pickedImage).onComplete;
    String link;
    if (snapshot.error == null) {
      link = await snapshot.ref.getDownloadURL();
    }
    return link;
  }

  final ProfileBloc profileBloc = ProfileBloc();

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
          backgroundColor: Color.fromRGBO(12, 12, 12, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.09),
            centerTitle: true,
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
          body: BlocProvider<ProfileBloc>(
            create: (_) => profileBloc,
            child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: profileBloc..add(GetInitialProfile()),
                builder: (BuildContext context, ProfileState state) {
                  if (state is ProfileInitial) {
                    return ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.teal[400],
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      state.user.photoUrl ??
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    ))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.teal[400],
                                  size: 30,
                                ),
                                onPressed: () async {
                                  final pickedImage = await getImage();
                                  final link = await uploadImage(pickedImage);
                                  BlocProvider.of<ProfileBloc>(context)
                                    ..add(ChangeProfilePicture(
                                        user: state.user, link: link));
                                })),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            state.user.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (state is Initial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProfilePictureChanged) {
                    return ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.teal[400],
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      state.user.photoUrl ??
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    ))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.teal[400],
                                  size: 30,
                                ),
                                onPressed: () async {
                                  final pickedImage = await getImage();
                                  final link = await uploadImage(pickedImage);
                                  BlocProvider.of<ProfileBloc>(context)
                                    ..add(ChangeProfilePicture(
                                        user: state.user, link: link));
                                })),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            state.user.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }),
          ),
        ));
  }
}
