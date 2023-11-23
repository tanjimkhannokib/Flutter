import 'package:campusepsilon/domains/entities/address.dart';
import 'package:campusepsilon/domains/repositories/address_repository.dart';

class GetAddress {
  final AddressRepository repository;

  GetAddress(this.repository);

  Future<Address> execute(String token, String addressId) {
    return repository.getAddress(
      token,
      addressId,
    );
  }
}
