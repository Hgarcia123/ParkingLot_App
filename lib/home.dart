import 'dart:convert';
//import 'dart:html' as html;
import 'dart:io';
import 'dart:ui';
import 'Maps.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:parkinglot/APIResponse.dart';
import 'package:parkinglot/Methods/park.dart';
import 'package:web_socket_channel/io.dart';



class Home extends StatelessWidget{
  const Home({Key? key}) : super(key: key);
  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Home'),
        ),
        body: HomePage()
      ),
      theme: ThemeData(
          primarySwatch: Colors.green
      ),

      debugShowCheckedModeBanner: false,

    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Future<Park> futurePark;
  ScrollController _controller = new ScrollController();

  List<ParkSpots> _listSpots = [];

  final parkId = 1;
  GetPark getPark = GetPark();

  var ws = new IOWebSocketChannel.connect('ws://192.168.0.196:5000');
  @override
  void initState() {
    super.initState();

    futurePark = getPark.getParkId(parkId);
    _createList();
    _listenMessages();
  }

  @override
  void dispose(){
    super.dispose();
    ws.sink.close();
  }
  

  void _listenMessages(){

    ws.stream.listen((event) {
      print('Message Received: $event');
      _createList();
    }
    );
  }

  void _onCreateList(List<dynamic>? list){
    _createList();
  }

  Future _createList() async{
    List<ParkSpots> listSpots = await getPark.getFreeSpots(parkId);
    setState(() {
      _listSpots = listSpots;
    });
  }

  Future _refresh(){
    return _createList();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: FutureBuilder<Park>(
                future: futurePark,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Text.rich(
                      TextSpan(
                          text: 'Welcome to Park: \n${snapshot.data?.name.toString()} - ${snapshot.data?.location.toString()}\n\n',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Total number of parking spots: ${snapshot.data?.maxSpots}', style: TextStyle(fontSize: 15)),
                        ]
                      )
                    );
                  }else if(snapshot.hasError){
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                }
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text('Available Spots:', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: _controller,
                itemCount: _listSpots.length,
                itemBuilder: (BuildContext context, int i){
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.airport_shuttle, size: 40,),
                          title: Text('Mark', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                          subtitle: Text(_listSpots[i].spot!.spotMark.toString(), style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Maps())
                                  );
                                },
                                child: Text('Go to spot')
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }
            )
          ),
        ),
      ],
    );
  }
}