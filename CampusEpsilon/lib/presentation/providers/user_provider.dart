import 'dart:async';

import 'package:flutter/material.dart';
import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/use_cases/user/auto_login.dart';
import 'package:campusepsilon/domains/use_cases/user/get_user.dart';
import 'package:campusepsilon/domains/use_cases/user/login.dart';
import 'package:campusepsilon/domains/use_cases/user/logout.dart';
import 'package:campusepsilon/domains/use_cases/user/save_user.dart';
import 'package:campusepsilon/domains/use_cases/user/sign_up.dart';
import 'package:campusepsilon/domains/use_cases/user/update_user.dart';
import 'package:campusepsilon/presentation/helper_variables/provider_state.dart';

class UserProvider with ChangeNotifier {
  final SignUp _signUp;
  final Login _login;
  final Logout _logout;
  final SaveUser _saveUser;
  final AutoLogin _autoLogin;
  final GetUser _getUser;
  final UpdateUser _updateUser;

  User? _user;

  User? get user => _user;
  String _message = "";

  String get message => _message;

  UserProvider({
    required SignUp signUp,
    required Login login,
    required Logout logout,
    required SaveUser saveUser,
    required AutoLogin autoLogin,
    required GetUser getUser,
    required UpdateUser updateUser,
  })  : _signUp = signUp,
        _login = login,
        _logout = logout,
        _saveUser = saveUser,
        _autoLogin = autoLogin,
        _getUser = getUser,
        _updateUser = updateUser;

  ProviderState _authState = ProviderState.empty;
  ProviderState _autoLoginState = ProviderState.empty;
  ProviderState _updateUserState = ProviderState.empty;

  ProviderState get authState => _authState;

  ProviderState get autoLoginState => _autoLoginState;

  ProviderState get updateUserState => _updateUserState;

  Future<void> autoLogin() async {
    try {
      _autoLoginState = ProviderState.loading;
      notifyListeners();

      final User user = await _autoLogin.execute();
      _user = user;
      _authState = ProviderState.loaded;
      _autoLoginState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _autoLoginState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> saveUser() async {
    try {
      await _saveUser.execute(_user!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String name}) async {
    _authState = ProviderState.loading;
    notifyListeners();

    try {
      final User user = await _signUp.execute(email, password, name);
      _user = user;
      _authState = ProviderState.loaded;
      notifyListeners();
      await saveUser();
    } catch (e) {
      _message = e.toString();
      _authState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    _authState = ProviderState.loading;
    notifyListeners();

    try {
      final User user = await _login.execute(email, password);
      _user = user;
      _authState = ProviderState.loaded;
      notifyListeners();
      await saveUser();
    } catch (e) {
      _message = e.toString();
      _authState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _logout.execute();
      _user = null;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUser({String? name, String? addressId}) async {
    _updateUserState = ProviderState.loading;
    notifyListeners();

    try {
      final User user = await _updateUser.execute(_user!.token!,
          name: name, addressId: addressId);
      _user = user;
      _updateUserState = ProviderState.loaded;
      notifyListeners();
      await saveUser();
    } catch (e) {
      _message = e.toString();
      _updateUserState = ProviderState.error;
      notifyListeners();
    }
  }
}
