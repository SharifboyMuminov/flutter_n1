import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_n1/data/dio/api_client.dart';
import 'package:flutter_n1/data/local/storage_repository.dart';
import 'package:flutter_n1/data/model/network_response.dart';
import 'package:flutter_n1/data/model/user_model.dart';

class ApiProvider {
  static final ApiClient _apiClient = ApiClient();

  static Future<NetworkResponse> createClient(
      {required String phoneNumber}) async {
    NetworkResponse networkResponse = NetworkResponse();

    try {
      final Response response = await _apiClient.dio.post(
        "http://95.130.227.117:81/client",
        data: {
          "firstName": "",
          "lastName": "",
          "phone": phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        networkResponse = await _sendCode(phoneNumber: phoneNumber);
        debugPrint(response.data.toString());
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }

  static Future<NetworkResponse> _sendCode(
      {required String phoneNumber}) async {
    NetworkResponse networkResponse = NetworkResponse();

    try {
      final Response response = await _apiClient.dio.get(
        "http://95.130.227.117:81/send-code?phone=%2B${phoneNumber.replaceAll("+", "")}",
      );

      // final Response response = await _apiClient.dio.get(
      //   "http://95.130.227.117:81/send-code",
      //   queryParameters: {
      //     'phone': phoneNumber.replaceAll("-", "%2B"),
      //   },
      // );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());

        networkResponse.data = response.data;
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }

  static Future<NetworkResponse> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    NetworkResponse networkResponse = NetworkResponse();

    try {
      final Response response = await _apiClient.dio.get(
        "http://95.130.227.117:81/verify?phone=%2B${phoneNumber.replaceAll("+", "")}&code=$code",
      );

      // final Response response = await _apiClient.dio.get(
      //   "http://95.130.227.117:81/verify",
      //   queryParameters: {
      //     'phone': phoneNumber.replaceAll("-", "%2B"),
      //     'code': code,
      //   },
      // );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());

        StorageRepository.setString(
            key: "token", value: response.data["data"]["token"]);
        StorageRepository.setInt(
            key: "user_id", value: response.data["data"]["user"]["id"]);

        networkResponse.data = response.data;
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }

  static Future<NetworkResponse> getUser() async {
    NetworkResponse networkResponse = NetworkResponse();

    int userId = StorageRepository.getInt(key: "user_id");

    try {
      final Response response = await _apiClient.dio.get(
        "http://95.130.227.117:81/api/users/$userId",
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());

        networkResponse.data = UserModel.fromJson(response.data["data"]);
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }

  static Future<NetworkResponse> updateUser(
      {required UserModel userModel}) async {
    NetworkResponse networkResponse = NetworkResponse();

    try {
      final Response response = await _apiClient.dio.put(
        "http://95.130.227.117:81/api/users/${userModel.id}",
        data: userModel.toJsonForUpdate(),
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }

  static Future<NetworkResponse> deleteUser(
      {required int userId}) async {
    NetworkResponse networkResponse = NetworkResponse();

    try {
      final Response response = await _apiClient.dio
          .delete("http://95.130.227.117:81/api/users/$userId");



      if (response.statusCode == 200) {
        StorageRepository.setInt(key: "user_id", value: 0);
        debugPrint(response.data.toString());
      } else {
        networkResponse.errorText = "Error status code ${response.statusCode}";
      }
    } catch (error) {
      networkResponse.errorText = error.toString();
    }

    return networkResponse;
  }
}
