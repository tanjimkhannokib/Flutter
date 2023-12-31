import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/repositories/user_repository.dart';

class SaveUser {
  final UserRepository repository;

  SaveUser(this.repository);

  Future<void> execute(User user) {
    return repository.saveUser(user);
  }
}
