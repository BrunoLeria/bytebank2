import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging.dart';

//java -jar server.jar

const String baseUrl = 'http://192.168.0.244:8080/transactions';
final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: const Duration(seconds: 15),
);
