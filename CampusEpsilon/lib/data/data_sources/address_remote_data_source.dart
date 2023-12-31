import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:campusepsilon/common/constants.dart';
import 'package:campusepsilon/common/env_variables.dart';
import 'package:campusepsilon/common/exception.dart';
import 'package:campusepsilon/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<AddressModel> addAddress(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  });

  Future<List<AddressModel>> getUserAddresses(String token);

  Future<AddressModel> getAddress(String token, String addressId);

  Future<AddressModel> updateAddress(
    String token,
    String addressId, {
    String? label,
    String? completeAddress,
    String? notes,
    String? receiverName,
    String? receiverPhone,
  });

  Future<AddressModel> deleteAddress(String token, String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final http.Client client;

  AddressRemoteDataSourceImpl({required this.client});

  @override
  Future<AddressModel> addAddress(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) async {
    final body = ({
      "label": label,
      "complete_address": completeAddress,
      "notes": notes,
      "receiver_name": receiverName,
      "receiver_phone": receiverPhone,
    }..removeWhere((key, value) => value == null || value.toString().isEmpty));

    final url = Uri.parse(BASE_URL).replace(path: '/addresses');

    final response = await client
        .post(
          url,
          headers: defaultHeader
            ..addEntries({"Authorization": "Bearer $token"}.entries),
          body: json.encode(body),
        )
        .timeout(const Duration(seconds: 5));

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return AddressModel.fromMap(responseBody["data"]["address"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<AddressModel> updateAddress(String token, String addressId,
      {String? label,
      String? completeAddress,
      String? notes,
      String? receiverName,
      String? receiverPhone}) async {
    try {
      final body = ({
        "label": label,
        "complete_address": completeAddress,
        "notes": notes,
        "receiver_name": receiverName,
        "receiver_phone": receiverPhone,
      }..removeWhere(
          (key, value) => value == null || value.toString().isEmpty));

      final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return AddressModel.fromMap(responseBody["data"]["address"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<AddressModel> deleteAddress(String token, String addressId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

      final response = await client
          .delete(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return AddressModel.fromMap(responseBody["data"]["address"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<AddressModel> getAddress(String token, String addressId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return AddressModel.fromMap(responseBody["data"]["address"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/addresses');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return List<AddressModel>.from(responseBody["data"]["results"]
            .map((x) => AddressModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
