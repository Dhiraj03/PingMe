import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';
import 'package:ping_me/features/auth/presentation/bloc/login_bloc/validators.dart';
import 'package:ping_me/features/messaging/data/firestore_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final FirestoreRepository _firestoreRepository;
  RegisterBloc(
      {@required UserRepository userRepository,
      FirestoreRepository firestoreRepository})
      : assert(userRepository != null),
        _firestoreRepository = firestoreRepository ?? FirestoreRepository(),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
          event.email, event.password, event.username);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapUsernameChangedToState(String username) async* {
    if (username.isEmpty)
      yield state.update(isUsernameValid: false);
    else {
      final res = await Validators.isValidUsername(username);
      yield state.update(isUsernameValid: res);
    }
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String email, String password, String username) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      print(username);
      _firestoreRepository.createUser(email, username);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
