import 'package:http/http.dart';

void findAll() async {
  final Response response =
      await get(Uri.parse('http://192.168.0.243:8080/transactions'));
  print(response.body);
}
