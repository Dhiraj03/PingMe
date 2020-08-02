import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:ping_me/features/messaging/presentation/screens/classic_dashboard.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';
import 'package:ping_me/features/messaging/presentation/screens/direct_message_screen.dart';
import 'package:ping_me/features/messaging/presentation/screens/search_screen.dart';
import 'package:ping_me/routes/router.gr.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardBloc dashboardBloc = DashboardBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: BlocProvider<DashboardBloc>(
          create: (BuildContext context) => dashboardBloc,
          child: BlocProvider<DashboardBloc>(
              create: (context) => dashboardBloc,
              child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (BuildContext context, DashboardState state) {
                if (state is ClassicDashboard)
                  return ClassicDashboardScreen();
                else if (state is Search) {
                  if (state.searchList.length > 0)
                    print(state.searchList[0].username);
                  return SearchScreen(searchList: state.searchList);
                } else if (state is DirectMessages)
                  return DirectMessageScreen(user : state.user2, chatRoomRef: state.chatRoomRef,self:state.self);
              })),
        ));
  }
}
