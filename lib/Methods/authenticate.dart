import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parkinglot/APIResponse.dart';

class Authenticate {
  Future<ApiResponse> login(String? username, String? password) async {

    var _apiResponse = ApiResponse();
    final _url = Uri.parse('http://192.168.0.196:5000/api/Authorization/LoginUser'); //10.0.2.2 = loopback
    Map<String, String> _headers = {'Content-Type':'application/json'};
    final _body  = {
    'userName': username,
    'password': password,
    };
    try{
      print(_body);
      final response = await http.post(_url, headers: _headers, body: jsonEncode(_body));
      var decodedBody = jsonDecode(response.body);

      _apiResponse.response = Response.fromJson('Unassigned');
      _apiResponse.error = Error.fromJson({'status': 0, 'title': 'Unassigned', 'errors': 'Unassigned'});

      print(decodedBody);
      print(response.statusCode);

      switch(response.statusCode){
        case 200:
          _apiResponse.response = Response.fromJson('Bearer ' + decodedBody); //Token
          print((_apiResponse.response as Response).message);
          break;
        case 401:
          _apiResponse.error = Error.fromJson(decodedBody);
          break;
        default:
          _apiResponse.error = Error.fromJson(decodedBody);
          break;
      }
    }on SocketException{
      _apiResponse.error = Error(errors: 'Server error');

    }
    return _apiResponse;
  }
}