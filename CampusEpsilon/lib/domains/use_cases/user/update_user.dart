import 'package:campusepsilon/domains/entities/user.dart';
import 'package:campusepsilon/domains/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<User> execute(String token, {String? name, String? addressId}) {
    return repository.updateUser(token, addressId: addressId, name: name);
  }
}
