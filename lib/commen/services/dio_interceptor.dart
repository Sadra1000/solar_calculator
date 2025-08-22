import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  Dio dio;
  DioInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({"Content-Type": "application/json"});
    print(options.uri);

    print(options.contentType);
    print(options.data);
    print(options.path);

    return super.onRequest(options, handler);
  }

  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  void onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }
}
