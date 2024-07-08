import 'package:dio/dio.dart';
import 'package:medical_monitor/providers/auth.dart';

Dio dio() {
  var dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api/',
      responseType: ResponseType.plain,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      requestInterceptor(options);
      return handler.next(options);
    },
  ));

  return dio;
}

dynamic requestInterceptor(RequestOptions options) async {
  if (options.headers.containsKey('auth')) {
    //  var token = await Auth().readToken();
    // options.headers.addAll({'Authorization': 'Bearer $token'});
  }
}
