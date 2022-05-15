import 'package:dio/dio.dart';
import 'package:forecast_project/src/core/utils/constants.dart';
import 'package:forecast_project/src/core/utils/my_functions.dart';

class NetBase {
  late Dio dio;
  final BaseOptions _baseOptions = BaseOptions(
    baseUrl: BASE_URL,
    sendTimeout: 60000,
    receiveTimeout: 60000,
    connectTimeout: 60000,
    contentType: 'application/json',
  );

  NetBase() {
    dio = Dio(_baseOptions);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        //checkConnection();
        myPrint("⬇⬇⬇ onRequest ⬇⬇⬇");
        myPrint(options.uri);
        myPrint(options.data);
        myPrint("⬆⬆⬆ onRequest ⬆⬆⬆");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        myPrint("⬇⬇⬇ onResponse ⬇⬇⬇");
        myPrint(response);
        myPrint("⬆⬆⬆ onResponse ⬆⬆⬆");
        return handler.next(response);
      },
      onError: (e, handler) async {
        myPrint("⬇⬇⬇ onError ⬇⬇⬇");
        myPrint(e.error);
        myPrint("⬆⬆⬆ onError ⬆⬆⬆");
        return handler.next(e);
      },
    ));
  }
}
