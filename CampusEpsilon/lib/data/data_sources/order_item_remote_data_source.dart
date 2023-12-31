import 'dart:async';
import 'dart:convert';

import 'package:campusepsilon/common/constants.dart';
import 'package:campusepsilon/common/exception.dart';
import 'package:campusepsilon/common/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:campusepsilon/data/models/order_item_model.dart';

abstract class OrderItemRemoteDataSource {
  Future<List<OrderItemModel>> getBuyerOrderItems(String token);

  Future<List<OrderItemModel>> getSellerOrderItems(String token);

  Future<OrderItemModel> getOrderItem(String token, String orderItemId);

  Future<OrderItemModel> cancelOrderItem(String token, String orderItemId);

  Future<OrderItemModel> processOrderItem(String token, String orderItemId);

  Future<OrderItemModel> sendOrderItem(String token, String orderItemId,
      {required String airwaybill});

  Future<OrderItemModel> completeOrderItem(String token, String orderItemId);
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final http.Client client;

  OrderItemRemoteDataSourceImpl({required this.client});

  @override
  Future<List<OrderItemModel>> getBuyerOrderItems(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/order-items/buyer');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return List<OrderItemModel>.from(responseBody["data"]["results"]
            .map((x) => OrderItemModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<OrderItemModel>> getSellerOrderItems(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/order-items/seller');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return List<OrderItemModel>.from(responseBody["data"]["results"]
            .map((x) => OrderItemModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<OrderItemModel> getOrderItem(String token, String orderItemId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/order-items/$orderItemId');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return OrderItemModel.fromMap(responseBody["data"]["order_item"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<OrderItemModel> cancelOrderItem(
      String token, String orderItemId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/order-items/$orderItemId/cancel');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return OrderItemModel.fromMap(responseBody["data"]["order_item"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<OrderItemModel> processOrderItem(
      String token, String orderItemId) async {
    try {
      final url = Uri.parse(BASE_URL)
          .replace(path: '/order-items/$orderItemId/process');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return OrderItemModel.fromMap(responseBody["data"]["order_item"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<OrderItemModel> sendOrderItem(String token, String orderItemId,
      {required String airwaybill}) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/order-items/$orderItemId/send');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode({"airwaybill": airwaybill}),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return OrderItemModel.fromMap(responseBody["data"]["order_item"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<OrderItemModel> completeOrderItem(
      String token, String orderItemId) async {
    try {
      final url = Uri.parse(BASE_URL)
          .replace(path: '/order-items/$orderItemId/complete');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return OrderItemModel.fromMap(responseBody["data"]["order_item"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
