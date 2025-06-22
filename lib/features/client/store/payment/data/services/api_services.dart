import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post(
      {required body,
      required String url,
        Map<String, String>? headers,
        required String token,
      String? contentType}) async {

    var respond = dio.post(
      url , data:  body ,
      options: Options(
        contentType: contentType,
        headers: headers ?? {'Authorization': "Bearer $token"},

      )
    );
    return respond;

  }
}
