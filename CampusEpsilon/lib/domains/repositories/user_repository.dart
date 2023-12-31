import 'package:campusepsilon/domains/entities/user.dart';

abstract class UserRepository {
  Future<User> signUp(String email, String password, String name);

  Future<User> login(String email, String password);

  Future<void> logout();

  Future<void> saveUser(User user);

  Future<User> autoLogin();

  Future<User> getUser(String token);

  Future<User> updateUser(String token,
      {String? name, String? addressId});
}
