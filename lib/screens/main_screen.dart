import 'dart:async';
import 'dart:core';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:users/Assistance/assistant_methods.dart';
import 'package:users/directions_repo.dart';
import 'package:users/global/map_key.dart';
import 'package:users/location_services.dart';
import 'package:users/splashScreen/splash_screen.dart';

import '../directions_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // String? address;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> controllerGmap =
      Completer<GoogleMapController>();

  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(lat, long),
    zoom: 14,
  );

  TextEditingController _searchController = TextEditingController();

  Position? userCurrentPosition;

  var geoLocation = Geolocator();

  LocationPermission? locationPermission;
  double bottomPaddingMap = 0;

  List<LatLng> pLineCoordinatedList = [];

  Set<Circle> circleSet = {};

  // String? userName = "";
  // String? userEmail = "";
  static const LatLng destination = LatLng(6.558731, 3.468737);

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();

  List<LatLng> polygonLatLng = <LatLng>[];

  int _polygonIdCount = 1;

  information() {
    print("this is info:${_info}");
  }

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(lat, long));
  }

  LatLng? newPoint;

  void _setMarker(LatLng point) async {
    setState(() {
      _markers.add(
          Marker(markerId: MarkerId("origin"), position: LatLng(lat, long)));

      _markers.add(
        Marker(markerId: MarkerId("destination"), position: point),
      );

      Marker? _destination = null;

      Directions? _info = null;
      newPoint = point;

      _getPolylines(LatLng(lat, long), point);
    });

    final directions = await DirectionsRepo()
        .getDirections(origin: _origin!.position, destination: point);
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(lat, long),
        PointLatLng(newPoint!.latitude, newPoint!.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
      setState(() {});
    }
  }

  Set<Polyline> _polylines = Set<Polyline>();

  void _getPolylines(LatLng origin, LatLng newPoint) {
    // TODO: Use the Directions API to get the polyline between origin and destination.
    // You need to make an API call and decode the response to get the polyline points.
    // For simplicity, we'll use dummy data here.
    List<LatLng> polylineCoordinates = [
      LatLng(lat, long),
      newPoint,
      LatLng(34.0522, -118.2437),
    ];

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ),
      );
    });
  }

  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {
    print(newPoint!.latitude);
    information();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 40,
          title: Text(
            "Trippa",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Where do you want to go"),
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                )),
                IconButton(
                    onPressed: () async {
                      var place = await LocationService()
                          .getPlace(_searchController.text);
                      goToPlace(place);
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            Expanded(
              child: Stack(alignment: Alignment.center, children: [
                GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  polygons: _polygons,
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("route"),
                        points: polylineCoordinates,
                        width: 4,
                        color: Colors.red)
                  },
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  buildingsEnabled: true,
                  circles: circleSet,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, long), zoom: 15),
                  onMapCreated: (controller) {
                    controllerGmap.complete(controller);
                  },
                ),
                if (_info != null)
                  Positioned(
                      top: 50.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0)
                            ]),
                        child: Text(
                          '${_info?.totalDistance}, ${_info?.totalDuration}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToPlace(Map<String, dynamic> place) async {
    final double latplace = place['geometry']["location"]['lat'];
    final double lngplace = place['geometry']["location"]['lng'];
    final GoogleMapController controller = await controllerGmap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latplace, lngplace), zoom: 16)));
    _setMarker(LatLng(latplace, lngplace));
  }

  Future<void> intialPos() async {
    final GoogleMapController controller = await controllerGmap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition));
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
            markerId: MarkerId("origin"),
            infoWindow: InfoWindow(title: "origin"),
            icon: BitmapDescriptor.defaultMarker,
            position: pos);
        // ignore: cast_from_null_always_fails
        Marker? _destination = null;
      });
    } else {
      setState(() {
        _origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "origin"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: pos,
        );
        // ignore: cast_from_null_always_fails
        Marker? _destination = null;
      });
    }
  }
}
