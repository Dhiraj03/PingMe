part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
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
  @override
  List get props => [];
}
