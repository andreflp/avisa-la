import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_integ/components/sidebar.dart';
import 'package:projeto_integ/pages/occurrence.dart';
import 'package:projeto_integ/services/auth.dart';

class Maps extends StatefulWidget {
  Maps({this.auth});

  final String title = "Avisa lá!";
  final AuthService auth;

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {
  @override
  void initState() {
    _getCurrentPosition();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  Marker marker;
  Circle circle;
  // LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<void> _getCurrentPosition() async {
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
            fillColor: Colors.blue.withAlpha(60));
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: Set.of((marker != null) ? [marker] : []),
              circles: Set.of((circle != null) ? [circle] : []),
              // onCameraMove: _onCameraMove,
            ),
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
                    button(
                        _getCurrentPosition, Icons.location_searching, 'btn2'),
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
              MaterialPageRoute(builder: (context) => Occurrence()),
            );
          },
          child: Icon(Icons.add),
        ), //
      ),
    );
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
