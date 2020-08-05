part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  @override
  List get props => [];
}

class DirectMessages extends DashboardState {
  final CollectionReference chatRoomRef;
  final User user2;
  final String self;
  DirectMessages({this.chatRoomRef, this.user2, this.self});
  @override
  List get props => <dynamic>[chatRoomRef];
}

class ClassicDashboard extends DashboardState {
  final Stream<QuerySnapshot> recentChats;
  final QuerySnapshot initialData;
  final String self;
  ClassicDashboard({@required this.recentChats, @required this.initialData, @required this.self});
  @override
  List get props => [];
}

class Search extends DashboardState {
  List<User> searchList;
  Search({@required this.searchList});
  @override
  List<Object> get props => [searchList];
}
