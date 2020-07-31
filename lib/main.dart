import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/auth/presentation/screens/home_screen.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:ping_me/features/auth/presentation/screens/login_screen.dart';
import 'package:ping_me/features/auth/presentation/screens/splash_screen.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;

  //An instance of user_Repository and AuthBloc is created
  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: _userRepository);
    _authBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return BlocProvider(
      create: (BuildContext context) => _authBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) {
          if (state is AppStarted) return SplashScreen();
          if (state is Authenticated)
            return HomeScreen(name: state.displayName);
          if (state is Unauthenticated)
            return LoginScreen(userRepository: _userRepository);
          return Container();
        }),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
