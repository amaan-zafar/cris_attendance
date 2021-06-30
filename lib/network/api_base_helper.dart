import 'package:cris_attendance/network/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  static const String _baseUrl = 'https://deploy-cris-db.herokuapp.com/webapi/';
  final http.Client httpClient;

  ApiProvider({required this.httpClient});

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await httpClient.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException('${response.statusCode}');
    }
  }
}
