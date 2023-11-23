import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<User> execute(String token) {
    return repository.getUser(token);
  }
}
