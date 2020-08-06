import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/messaging/presentation/screens/classic_dashboard.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';
import 'package:ping_me/features/messaging/presentation/screens/direct_message_screen.dart';
import 'package:ping_me/features/messaging/presentation/screens/profile_screen.dart';
import 'package:ping_me/features/messaging/presentation/screens/search_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final DashboardBloc dashboardBloc = DashboardBloc();

  PageController pageController;
  TabController tabController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.09),
      bottomNavigationBar: TabBar(
          onTap: (int tabIndex) {
            tabController.index = tabIndex;
            pageController.jumpToPage(tabIndex);
          },
          controller: tabController,
          indicatorColor: Colors.teal[400],
          labelColor: Colors.teal[400],
          unselectedLabelColor: Color.fromRGBO(255, 255, 255, 0.30),
          tabs: <Widget>[
            Tab(icon: Icon(Icons.chat)),
            Tab(icon: Icon(Icons.person))
          ]),
      body: PageView(
        onPageChanged: (int pageIndex) {
          tabController.index = pageIndex;
          pageController.jumpToPage(pageIndex);
        },
        controller: pageController,
        allowImplicitScrolling: true,
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.blueGrey,
            body: BlocProvider<DashboardBloc>(
                create: (context) => dashboardBloc..add(GetInitialChats()),
                child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (BuildContext context, DashboardState state) {
                  if (state is DashboardInitial)
                    return Center(child: CircularProgressIndicator());
                  else if (state is ClassicDashboard)
                    return ClassicDashboardScreen(
                        self: state.self,
                        initialData: state.initialData,
                        recentChats: state.recentChats);
                  else if (state is Search) {
                    if (state.searchList.length > 0)
                      print(state.searchList[0].username);
                    return SearchScreen(searchList: state.searchList);
                  } else if (state is DirectMessages)
                    return DirectMessageScreen(
                        user: state.user2,
                        chatRoomRef: state.chatRoomRef,
                        self: state.self);
                })),
          ),
          ProfileScreen()
        ],
      ),
    );
  }
}
