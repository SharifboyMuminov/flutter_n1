import 'package:dio/dio.dart';
import 'package:flutter_n1/data/local/storage_repository.dart';

class ApiClient {
  ApiClient() {
    _init();
  }

  late Dio dio;
  late Dio securityDio;

  void _init() {
    dio = Dio();
    securityDio = Dio();

    securityDio.options = BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": StorageRepository.getString(key: "token")
      },
      receiveTimeout: const Duration(seconds: 10),
    );

    dio.options = BaseOptions(
      headers: {
        'Content-Type': 'application/json',
      },
      receiveTimeout: const Duration(seconds: 10),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    securityDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }
}
