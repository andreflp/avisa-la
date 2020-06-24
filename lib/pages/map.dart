import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_integ/components/sidebar.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/pages/occurrence.dart';
import 'package:projeto_integ/services/auth.dart';
import 'package:projeto_integ/services/ocurrence_service.dart';
import 'dart:ui' as ui;

class Maps extends StatefulWidget {
  Maps({this.auth});

  final String title = "Avisa lá!";
  final AuthService auth;

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Future<GoogleMapController> _futureCurrentPosition;
  Future<String> _futureCamera;
  OccurrenceService occurrenceService = OccurrenceService();
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(27.6094844, -48.7502849);
  Marker marker;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Circle circle;
  // LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    _futureCurrentPosition = _getCurrentPosition();
    fetchOccurrences();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Future<GoogleMapController> _getCurrentPosition() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      CameraPosition cameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        tilt: 10,
        zoom: 17.0,
      );
      final GoogleMapController controller = await _controller.future;
      LatLng center = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        marker = Marker(
          markerId: MarkerId(center.toString()),
          position: center,
          infoWindow: InfoWindow(
            title: 'Você esta aqui!',
            snippet: 'Você esta aqui!',
          ),
          rotation: position.heading,
          draggable: false,
          flat: true,
          icon: BitmapDescriptor.defaultMarker,
        );
        circle = Circle(
            circleId: CircleId("position"),
            radius: position.accuracy,
            zIndex: 1,
            strokeColor: Colors.blue,
            center: center,
            fillColor: Colors.blue.withAlpha(20));
      });

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      return controller;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Widget button(Function function, IconData icon, String tagName) {
    return FloatingActionButton(
      heroTag: tagName,
      mini: true,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: homeScaffoldKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          drawer: NavDrawer(widget.auth, context),
          body: Stack(
            children: <Widget>[
              FutureBuilder(
                  future: _futureCurrentPosition,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return Text(
                              'Erro ao carregar o mapa: ${snapshot.error}');
                        return GoogleMap(
                          onMapCreated: _onMapCreated,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                          mapType: _currentMapType,
                          markers: Set.of(_markers.values),
                          circles: Set.of((circle != null) ? [circle] : []),
                          // onCameraMove: _onCameraMove,
                        );
                    }
                    return null;
                  }),
              Positioned(
                left: 10,
                top: 15,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  iconSize: 30.0,
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      button(_onMapTypeButtonPressed, Icons.map, 'btn1'),
                      SizedBox(
                        height: 12.0,
                      ),
                      button(_getCurrentPosition, Icons.location_searching,
                          'btn2'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                Transition(widget: OccurrencePage()),
              );
            },
            child: Icon(Icons.add),
          ), //
        ));
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> fetchOccurrences() async {
    List<Occurrence> occurrencies = await occurrenceService.fetchAll();

    for (var i = 0; i < occurrencies.length; i++) {
      var occurrence = occurrencies[i];
      BitmapDescriptor bmd = await setMarkerIcon(occurrence.gravity);

      final MarkerId markerId = MarkerId(occurrence.id);
      _markers[markerId] = Marker(
          markerId: markerId,
          position: LatLng(occurrence.lat, occurrence.long),
          icon: bmd);
    }
  }

  Future<BitmapDescriptor> setMarkerIcon(gravity) async {
    String icon;

    if (gravity == "Alta") {
      icon = 'high';
    } else if (gravity == "Média") {
      icon = 'regular';
    } else {
      icon = 'low';
    }

    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/icon-$icon.png');
  }

  signOut(BuildContext context) async {
    try {
      await widget.auth.signOut();
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      print(e);
    }
  }
}
