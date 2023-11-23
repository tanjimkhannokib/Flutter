import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/repositories/user_repository.dart';

class SignUp {
  final UserRepository repository;

  SignUp(this.repository);

  Future<User> execute(String email, String password, String name) {
    return repository.signUp(email, password, name);
  }
}
