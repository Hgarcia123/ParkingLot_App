import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Maps extends StatelessWidget{
  const Maps({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Location'),
      ),
      body: MapPage()
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  late MapZoomPanBehavior _zoomPanBehavior;
  String apiKey = 'AoPujk69oSIq3EMcvsv8TTYfGOdJMm4O0QnWM2Au7o7Tl_rLBHsaVYB-ows2uCCt';

  @override
  void initState(){
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior();
  }
  /*
  @override
  Widget build(BuildContext context){
    return SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialZoomLevel: 15,
            initialFocalLatLng: MapLatLng(38.69492, -8.9407),
            zoomPanBehavior: _zoomPanBehavior,
          )
        ]);
  }
   */


  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        child: FutureBuilder(
          future: getBingUrlTemplate(
              'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOnDemand?output=json&uriScheme=https&include=ImageryProviders&key='+apiKey),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
              final String url = snapshot.data;
              return SfMaps(
                  layers: [
                    MapTileLayer(
                      initialFocalLatLng: MapLatLng(38.694691,-8.940555),
                      initialZoomLevel: 15,
                      zoomPanBehavior: _zoomPanBehavior,
                      urlTemplate: url
                    )
                  ]
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        )
      ),
    );
  }
}

