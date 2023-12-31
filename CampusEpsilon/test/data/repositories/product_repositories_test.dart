import 'package:flutter_test/flutter_test.dart';
import 'package:campusepsilon/data/data_sources/product_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:campusepsilon/data/data_sources/remote_storage_service.dart';
import 'package:campusepsilon/data/repositories/product_repository_impl.dart';

void main() {
  late ProductRepositoryImpl repository;

  setUp(() {
    repository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(client: http.Client()),
      remoteStorageService: RemoteStorageServiceImpl(),
    );
  });

  group("Get Product", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await repository.getProduct("63e91cbfcb3199d254550b73");
        print(result.name);
      } catch (e) {
        rethrow;
      }
    });
  });
  group("Search Product", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final results = await repository.searchProduct();
        print(results);
      } catch (e) {
        rethrow;
      }
    });
  });
  group("Search Product", () {
    test('sgergerregresdfds', () async {
      try {
        final results = await repository.getPopularProducts();
        print(results);
      } catch (e) {
        rethrow;
      }
    });
  });
}
