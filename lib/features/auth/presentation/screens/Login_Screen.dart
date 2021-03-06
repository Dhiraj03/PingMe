import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:ping_me/features/auth/presentation/screens/Login_Form.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;
  
  //The LoginScreen also receives the instance of the UserRepository from a parent class.
  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.09),
      body: BlocProvider<LoginBloc>(
        create: (_) => _loginBloc,
        child: 
            LoginForm(userRepository: _userRepository)
          
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
