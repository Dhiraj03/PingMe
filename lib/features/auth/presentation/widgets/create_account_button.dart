import 'package:flutter/material.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/auth/presentation/screens/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(
          color: Colors.teal[400]
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<dynamic>(builder: (context) {
            return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}

