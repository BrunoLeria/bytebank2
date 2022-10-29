import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging.dart';

const String baseUrl = 'http://192.168.0.243:8080/transactions';
final Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);
