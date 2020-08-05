part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class GetInitialChats extends DashboardEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
  
}

class Searching extends DashboardEvent {
  final String searchTerm;
  Searching({@required this.searchTerm});
  @override
  List get props => [searchTerm];
}

class OpenDM extends DashboardEvent {
  final String uid2;
  OpenDM({@required this.uid2});
  @override
  List get props => [uid2];
}

class GotoDashboard extends DashboardEvent {
  final String uid;
  GotoDashboard({@required this.uid});
  @override
  List get props => [];
}
