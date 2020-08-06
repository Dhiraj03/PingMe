import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';
import 'package:ping_me/features/messaging/presentation/dashboard_bloc/dashboard_bloc.dart';
import 'package:ping_me/features/messaging/presentation/screens/direct_message_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<User> searchList;

  SearchScreen({Key key, this.searchList}) : super(key: key) {
    print('wtf');
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<User> get _searchList => widget.searchList;

  Future<bool> willPopCallBack(BuildContext mainContext) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.15),
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit to the dashboard?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(mainContext).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.teal[400]),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<DashboardBloc>(mainContext)
                      .add(GotoDashboard());
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.teal[400]),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => willPopCallBack(context),
        child: Scaffold(
        backgroundColor: Color.fromRGBO(12, 12, 12, 1),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_back),
            backgroundColor: Colors.teal[400],
            onPressed: () {
              BlocProvider.of<DashboardBloc>(context).add(GotoDashboard());
            }),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
              
                autofocus: true,
                cursorColor: Colors.teal[400],
                cursorRadius: Radius.circular(10),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal[400]
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color :  Colors.teal[400]),
                  hintText: 'Search for a user',
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.teal[400])),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[400]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[400]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                controller: searchController,
                onChanged: (_) {
                  BlocProvider.of<DashboardBloc>(context)
                      .add(Searching(searchTerm: searchController.text));
                },
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _searchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print('tapped');
                      BlocProvider.of<DashboardBloc>(context)
                          .add(OpenDM(uid2: _searchList[index].uid));
                    },
                    child: searchTile(
                        _searchList[index].username, _searchList[index].email),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget searchTile(String username, String email) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text('Username : ' + username, style: TextStyle(color: Colors.teal[400]),),
              SizedBox(
                height: 10,
              ),
              Text('Email : ' + email, style: TextStyle(color: Colors.teal[400]),),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromRGBO(255, 255, 255, 0.09),
                indent: 35,
                endIndent: 35,
                thickness: 1.0,
              ),
            ]),
      ),
    );
  }
}
