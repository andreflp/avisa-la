import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:projeto_integ/components/sidebar.dart';
import 'package:projeto_integ/components/transition.dart';
import 'package:projeto_integ/models/occurrence_model.dart';
import 'package:projeto_integ/pages/login/login.dart';
import 'package:projeto_integ/pages/occurrence/occurrence.dart';
import 'package:projeto_integ/pages/occurrence/occurrence_image.dart';
import 'package:projeto_integ/services/auth.dart';
import 'package:projeto_integ/services/occurrence_service.dart';
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
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  OccurrenceService occurrenceService = OccurrenceService();
  Completer<GoogleMapController> _controller = Completer();
  Future<GoogleMapController> _futureCurrentPosition;
  Future<void> _fetchOccurrencies;
  LatLng _center = LatLng(27.6094844, -48.7502849);
  Marker marker;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  // LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor iconCurrentLocation;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setCurrentLocationIcon();
    _futureCurrentPosition = _getCurrentPosition();
    _fetchOccurrencies = fetchOccurrences();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Future<GoogleMapController> _getCurrentPosition() async {
    setState(() {
      loading = true;
    });
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      CameraPosition cameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        tilt: 10,
        zoom: 15.0,
      );
      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {
        loading = false;
      });
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

  void setCurrentLocationIcon() async {
    iconCurrentLocation = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/current-position.png');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: homeScaffoldKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          drawer: NavDrawer(widget.auth, context),
          body: LoadingOverlay(
            color: Colors.grey,
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                    future: _fetchOccurrencies,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return MaterialApp(
                            home: Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                              backgroundColor: Colors.white,
                            ),
                          );
                        case ConnectionState.done:
                          return GoogleMap(
                            onMapCreated: _onMapCreated,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 11.0,
                            ),
                            mapType: _currentMapType,
                            markers: Set.of(_markers.values),
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
            isLoading: loading,
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
    setState(() {
      loading = true;
    });
    List<Occurrence> occurrencies = await occurrenceService.fetchAll();

    for (var i = 0; i < occurrencies.length; i++) {
      var occurrence = occurrencies[i];
      BitmapDescriptor bmd = await setMarkerIcon(occurrence.severity);

      final MarkerId markerId = MarkerId(occurrence.id);
      _markers[markerId] = Marker(
          markerId: markerId,
          infoWindow: InfoWindow(
            onTap: () => {
              Navigator.push(
                context,
                Transition(widget: OccurrenceImagePage(occurrence)),
              )
            },
            title: makeEllipsis(occurrence.location),
            snippet: makeEllipsis(occurrence.description),
          ),
          position: LatLng(occurrence.lat, occurrence.long),
          icon: bmd);
    }

    setState(() {
      loading = false;
    });
  }

  Future<BitmapDescriptor> setMarkerIcon(severity) async {
    String icon;

    if (severity == "Alta") {
      icon = 'high';
    } else if (severity == "Média") {
      icon = 'regular';
    } else {
      icon = 'low';
    }

    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/icon-$icon.png');
  }

  String makeEllipsis(String text) {
    if (text.length < 30) {
      return text;
    } else {
      return "${text.substring(0, 30)}...";
    }
  }
}
