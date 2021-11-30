import 'dart:convert';
import 'dart:io';
import 'package:parkinglot/globals.dart' as globals;

import 'package:http/http.dart' as http;
import 'package:parkinglot/APIResponse.dart';

class GetPark{
  Future<Park> getParkId(int parkId) async {
    final _url = Uri.parse('http://192.168.0.196:5000/api/Park/GetParkId/');

    try{
      var token = await globals.storage.read(key: "Jwt");

      final response = await http.get(_url, headers: {HttpHeaders.authorizationHeader: token.toString(), 'parkId': '$parkId'});
      var decodedBody = jsonDecode(response.body);

      print("Body of Park: " + response.body);
      //print("Decoded body of park: " + decodedBody[0]);

      switch(response.statusCode){
        case 200:
          return Park.fromJson(decodedBody[0]);
      }
    }on SocketException {
      throw new Exception("Server Error");
    }
    return Park.fromJson({'id': 0, 'name': 'Unassigned', 'location': 'Unassigned', 'maxSpots' : '0'});
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<ParkSpots>> getFreeSpots(int parkId) async{
    final _url = Uri.parse('http://192.168.0.196:5000/api/Search/FreeSpotsInPark');
    
    try{
      var token = await globals.storage.read(key: "Jwt");

      final response = await http.get(_url, headers: {HttpHeaders.authorizationHeader: token.toString(), 'parkId' : '$parkId'});
      var decodedBody = jsonDecode(response.body);

      print(response.body);

      switch(response.statusCode){
        case 200:
          return new List<ParkSpots>.from(decodedBody.map((i) => ParkSpots.fromJson(i)));
      }
    }on SocketException{
      throw new Exception("Server Error");
    }
    return [];
  }
}