import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';

class ClassicDashboardScreen extends StatefulWidget {
  @override
  _ClassicDashboardScreenState createState() => _ClassicDashboardScreenState();
}

class _ClassicDashboardScreenState extends State<ClassicDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        BlocProvider.of<DashboardBloc>(context).add(Searching(searchTerm: ''));
      }),
    );
  }
}
