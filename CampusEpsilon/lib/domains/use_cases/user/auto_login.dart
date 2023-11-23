import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/repositories/user_repository.dart';

class AutoLogin {
  final UserRepository repository;

  AutoLogin(this.repository);

  Future<User> execute() {
    return repository.autoLogin();
  }
}
