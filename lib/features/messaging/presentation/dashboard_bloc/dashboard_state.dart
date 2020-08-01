part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class DirectMessages extends DashboardState {
  final String uid2;
  DirectMessages({this.uid2});
  @override
  List get props => <dynamic>[uid2];
}

class Search extends DashboardState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
  
}
