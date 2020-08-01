import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:ping_me/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:ping_me/features/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:ping_me/features/auth/presentation/widgets/Register_button.dart';

//read login_form.dart for documentation
class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty;

  /* Checks whether the form is valid and populated and is not in the submission phase - only then 
     enables the Register Button
  */
  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Typicons.chat_alt,
                    size: 70,
                    color: Colors.purple,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(height: 100),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.purple,
                      ),
                      labelText: 'Email',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.purple,
                      ),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesome.user,
                        color: Colors.purple,
                      ),
                      labelText: 'Username',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isUsernameValid ? 'Invalid Username' : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RegisterButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onUsernameChanged() {
    _registerBloc.add(UsernameChanged(username: _usernameController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text
      ),
    );
  }
}
