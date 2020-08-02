part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
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
  @override
  List get props => [];
}

class Search extends DashboardState {
  List<User> searchList;
  Search({@required this.searchList});
  @override
  List<Object> get props => [searchList];
}
