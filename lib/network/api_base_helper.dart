import 'package:cris_attendance/network/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  static const String _baseUrl = 'https://api.football-data.org/v2/';
  static const String _apiKey = '0bfa08b467cc4a2f84f1481a79d4b113';
  final http.Client httpClient;

  ApiProvider({required this.httpClient});

  Future<dynamic> get(String url, {required bool requireApiKey}) async {
    var responseJson;
    try {
      if (requireApiKey) {
        final response = await httpClient
            .get(Uri.parse(_baseUrl + url), headers: {'X-Auth-Token': _apiKey});
        responseJson = _response(response);
      } else {
        final response = await httpClient.get(Uri.parse(_baseUrl + url));
        responseJson = _response(response);
      }
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
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
