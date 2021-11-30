import 'package:json_annotation/json_annotation.dart';

class ApiResponse{
  Object? park;
  Object? error;
  Object? response;

  Object? get Park => park;
  set Park(Object? park) => this.park = park;

  Object? get Error => error;
  set Error(Object? error) => this.error = error;

  Object? get Response => response;
  set Response(Object? response) =>  this.response = response;
}

class Error{
  int? status;
  String? title;
  String? errors;

  Error({
    this.status,
    this.title,
    this.errors
  });

  factory Error.fromJson(Map<dynamic, dynamic> json){
    return Error(
        status: json['status'],
        title: json['title'],
        errors: json['errors']
    );
  }
}

class Park{
  int? id;
  String? name;
  String? location;
  int? maxSpots;

  Park({
    this.id,
    this.name,
    this.location,
    this.maxSpots});


  factory Park.fromJson(Map<String, dynamic> json){
    return Park(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      maxSpots: json['maxSpots']
    );
  }
}
@JsonSerializable(explicitToJson: true)
class ParkSpots{
  bool? status;
  Spots? spot;

  ParkSpots({
    this.status,
    this.spot
  });

  factory ParkSpots.fromJson(Map<String, dynamic> json){
    var list = json['spot'];
    print(list.runtimeType);
    //List<String> _spotList = list.map((i) => Spots.fromJson(i)).toList();
    return ParkSpots(
      status: json['status'],
      spot:Spots.fromJson(json['spot'])
    );
  }

  @override
  String toString(){
    return '{ ${this.status}, ${this.spot} }';
  }
}
class Spots{
  int? id;
  String? spotMark;

  Spots({
    this.id,
    this.spotMark,
});

  factory Spots.fromJson(Map<dynamic, dynamic> json){
    return Spots(
      id: json['id'],
      spotMark: json['spotMark'],
    );
  }
}

class Response{
  String? message;

  Response({String? message}) {
    this.message = message;
  }

  String? get Message => this.message;
  set Message(String? message) => this.message = message;

  factory Response.fromJson(String json){
    return Response(message: json);
  }
}